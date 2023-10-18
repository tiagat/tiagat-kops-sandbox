# Karpenter PoC

## Тестове оточення

Доя виконання задачі мені потрібен сам кластер Kubernetes, оскільки у нас в інфраструктурі використовується kOps то логічно було створити тестове оточення (пісочницю) на його основі. Ну і мені додаткова практика

Тестова інфраструктура розгорнута через Terraform в прватному AWS профілі

```
# providers.tf

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

![image](./images//Screenshot%202023-10-18%20at%2010.00.13.png)

## Karpenter
