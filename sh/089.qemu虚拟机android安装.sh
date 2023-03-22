apt install qemu qemu-kvm libvirt-bin
#创建虚拟机
qemu-img create -f qcow2 android.img 40G
#安装
sudo qemu-system-x86_64 -m 4096 -boot d -enable-kvm -smp 3 -net nic -net user -hda android.img -cdrom /media/yangyong/d4y/soft/android/android-x86_64-9.0-r2.iso
#启动
sudo qemu-system-x86_64 -m 4096 -boot d -enable-kvm -smp 3 -net nic -net user -hda android.img













