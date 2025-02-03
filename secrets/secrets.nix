let
  bestest = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUXsMyXC9Ono4ErYoBRtiW5qEYNATBgsGhB4La1ViExtrSFNU1K5Cx3wcl7zLcNtUPxJFV++uRdLvybbb4cLFUxgTSU6I+CBm9deKq3xFCp6gEdHz1MBuC2VJJm8EVQt1s0wiCRDYMFJDcWeb+3a+wSd19LtQiVZhgySEGREUZ8Ay7DGp7Ta3rS7NMeXRGjXayJi/QULPr6c0ZswaW463jgTSWPNEhzHoosF1xML4CV6WdW8nwuI9UaO90GCgd2AxySeQ0P+Qyh2CXAquHp8Q+OJHV7uYmXNxQe+et8aDlMnTNInUyo8/LS5KCRnmd/rQg+ZRMQXq32rJE5JuRzuTkha1Tc38vNQBkSRvMawASHzpYdDwSHfZk7Yo61fUwaND8NnAhB7eIUGVdsuPlZdJnwJ4vKIn1xJr4+3dHgTZRZYV+PXzYoFlEOcFDh0voXJmqveRwLXD9WxvaJXJ8/AvrWQq/06fg+MzH8ujFoDMTY/j1wH2VqgoiRdopDnjD+RNI4XMw9IuhmJk48ky0tvTX2WFrFwCc7MJrTUF/RVq2MqRmbznkFRuCiS/DvkBKauxMliv3VPcJfTPXHjhotr8DV95nzBuGru/QmNkig4Sg28WStqaUMTFCkBZQaxWuKn/8ExvqIsxV1ZFywRXxmjSnkin2UUBDGJzMbjl/ZAgzzw== techlord18@gmail.com";
  users = [ bestest ];

  urithiru = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlDk77GECOS49xaLKFQ4Att5YuZXvaTWLVsTryxSTVR root@urithiru";
  systems = [ urithiru ];
in {
  "cloudflare-env.age".publicKeys = [ bestest urithiru ];
  "curseforge-env.age".publicKeys = [ bestest urithiru ];
  "murmur-env.age".publicKeys = [ bestest urithiru ];
  "frp-toml.age".publicKeys = [ bestest urithiru ];
}
