# rebrain-k8s-networking
Stuff for webinar @ rebrain

Playlist: [https://youtube.com/playlist?list=PLVsDW8WKTo5FnrmnBBojRd6Pbkc-DuRmr](https://youtube.com/playlist?list=PLVsDW8WKTo5FnrmnBBojRd6Pbkc-DuRmr)

Rebrain: [https://rebrainme.com/](https://rebrainme.com/)

Presentation: [Slides](https://docs.google.com/presentation/d/1X8h9w1hdbe70zHCGW6BZlyqyTGMunaUoiMV96ko_y8s/edit?usp=sharing)

Webinar: Contact me via telegram for link

Codez:

- [Cisco Netdevops talk (github)](https://github.com/ciscodevnet/netdevops-live-0213/)
- [Cisco Netdevops talk (youtube)](https://www.youtube.com/watch?v=z-ITjDQT7DU&list=PLVsDW8WKTo5FnrmnBBojRd6Pbkc-DuRmr&index=1)
- [CNI in bash from scratch (github)](https://github.com/eranyanay/cni-from-scratch)
- [CNI in bash from scratch (youtube)](https://www.youtube.com/watch?v=zmYxdtFzK6s&list=PLVsDW8WKTo5FnrmnBBojRd6Pbkc-DuRmr&index=15)
- [Container networking from scratch (github)](https://github.com/kristenjacobs/container-networking/)
- [Container networking from scratch (youtube)](https://www.youtube.com/watch?v=6v_BDHIgOY8&list=PLVsDW8WKTo5FnrmnBBojRd6Pbkc-DuRmr&index=16)
- [Kubernetes Networking: How to Write Your Own CNI Plug-in with Bash](https://www.altoros.com/blog/kubernetes-networking-writing-your-own-simple-cni-plug-in-with-bash/)
- [Container networking is simple!](https://iximiuz.com/en/posts/container-networking-is-simple/)
- [Container networking is simple! (in Russian)](https://habr.com/ru/company/timeweb/blog/558612/)
- [Foo over UDP](https://lwn.net/Articles/614348/)

## Multiarch build on linux

```
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
docker buildx create --use
docker buildx build --push --tag lllamnyp/rebrain-utils:latest --platform linux/amd64,linux/arm64 .
```
