# Karpenter PoC

## Тестове оточення

Доя виконання задачі мені потрібен сам кластер Kubernetes, оскільки у нас в інфраструктурі використовується kOps то логічно було створити тестове оточення (пісочницю) на його основі. Ну і мені додаткова практика

Тестова інфраструктура розгорнута через Terraform в прватному AWS профілі

```
terraform {

    required_version = ">= 1.2.6"

    kops = {
      source  = "eddycharly/kops"
      version = "1.25.4"
    }

  }
}

```

Всі скрипти в можна подивтися тут [tiagat/kops-karpenter-poc](https://github.com/tiagat/kops-karpenter-poc)

Тестовий кластер:

![image](./images/Screenshot-20231018-100013.png)

## Karpenter

Для роботи з Karpenter через kOps треба аказати "feature flag":

```
export KOPS_FEATURE_FLAGS="Karpenter"
```

І немає значення, ми працюємо з CLI чи модулями Terraform. Без цьої змінної будь-яка спроба використання Karpenter в конфігурації кластера призведе до помилки

![image](./images/Screenshot-20231018-085935.png)

### Інсталяція

Karpenter як продукт складається з двох компонентів:

- Controller (сервіс який безпосередньо виконує функцію масштабування)
- Provisioner (CRD з конфішурацією поведінки скейлера)

в kOps є готова інтеграція з Karpenter ([kOps managed addons](https://kops.sigs.k8s.io/addons/#karpenter)) тому сам проце інсталяції на новому кластері максимально простий

- підготувати S3 бакет і IAM політики
- увімкнути Karpenter в конфігурації кластера
- вказати Karpenter як `manager` для русурсі `kops_instance_group`

EC2 ноди

![image](./images//Screenshot-20231018-102138.png)

Kubernetes ресурси

![image](./images/Screenshot-20231018-102355.png)
![image](./images/Screenshot-20231018-102409.png)
![image](./images/Screenshot-20231018-102421.png)
![image](./images/Screenshot-20231018-102442.png)

## Перевірка роботи скейлера

- inflate `public.ecr.aws/eks-distro/kubernetes/pause:3.7`
- візуалізація: `hjacobs/kube-ops-view:23.5.0`

Step 1: initial state

![image](./images/Screenshot-20231018-103417.png)

Step 2: scale `inflate` from 0 to 16 replicas

![image](./images//Screenshot-20231018-103854.png)

- скейлер прийняв рішення, створив ноду `i-05bf99579f966fce1` яка перейшла в стен **READY** - за 2 хвилини

![image](./images/Screenshot-20231018-103717.png)
![image](./images/Screenshot-20231018-103821.png)

- зворотній процес відбувається практично відразу (на конфігурації по замовчуванню)

## Про що варто поговорити
