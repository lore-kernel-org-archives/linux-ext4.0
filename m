From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: ext4 error when testing virtio-scsi & vhost-scsi
Date: Tue, 12 Jul 2016 15:14:38 +0800
Message-ID: <CAMj5BkgSXjD+_GB_VPgizowyyJ1uYxLiKd7ehQmEdVvnuY55cA@mail.gmail.com>
References: <CAMj5BkiVGQ4dAUY+wi-+O4qRdVS6YPiUP2BpsiE5y0r+2AhLgw@mail.gmail.com>
 <CAMj5BkiKC2m3PLHvoDWwyj9BQZ-Bg5mD0f1J0kZcpwroH+rR1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: kvm@vger.kernel.org, qemu-devel@nongnu.org,
	target-devel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAMj5BkiKC2m3PLHvoDWwyj9BQZ-Bg5mD0f1J0kZcpwroH+rR1g@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Some update:

If test with ext2, no problem in iblock.
If test with ext4, ext4_mb_generate_buddy reported error in the
removing files after reboot.


root@(none)$ rm test
[   21.006549] EXT4-fs error (device sda): ext4_mb_generate_buddy:758: group 18
, block bitmap and bg descriptor inconsistent: 26464 vs 25600 free clusters
[   21.008249] JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 0). Th
ere's a risk of filesystem corruption in case of system crash.

Any special notes of using ext4 in qemu?

Thanks


On Mon, Jul 11, 2016 at 12:05 PM, Zhangfei Gao <zhangfei.gao@gmail.com> wrote:
> Hi
>
> Does qemu process need flush data before closing?
>
> In the test of virtio_scsi & vhost_scsi, the first time read & write
> to the mounted disk have no problem.
> But after reboot, remount the disk, error happen immediately when
> remove the files created in the first time.
>
> For example:
> # targetcli
> /> cd backstores/iblock
> /backstores/iblock> create name=block_backend dev=/dev/sda3
> /backstores/iblock> cd /vhost
> /vhost> create wwn=naa.60014053c5cc00ac
> /vhost> ls
> o- vhost ............................................................ [1 Target]
>   o- naa.60014053c5cc00ac .............................................. [1 TPG]
>     o- tpg1 ............................................. [naa.6001405830beacfa]
>       o- luns ......................................................... [0 LUNs]
> /vhost> cd naa.60014053c5cc00ac/tpg1/luns
> /vhost/naa.60...0ac/tpg1/luns> create /backstores/iblock/block_backend
>
> qemu.git/aarch64-softmmu/qemu-system-aarch64 \
>     -enable-kvm -nographic -kernel Image \
>     -device vhost-scsi-pci,wwpn=naa.60014053c5cc00ac \
>     -m 512 -M virt -cpu host \
>     -append "earlyprintk console=ttyAMA0 mem=512M"
>
> in qemu system:
> mount /dev/sda /mnt;
>
> sync; date; dd if=/dev/zero of=/mnt/test bs=1M count=100; sync; date;
>
> no problem for several times.
>
> Reboot
> targetcli config -> start qemu again.
> in qemu:
>
> mount /dev/sda /mnt;
>
> root@(none)$ rm test
> [   12.900540] EXT4-fs error (device sda): ext4_mb_generate_buddy:758: group 3s
> [   12.908844] EXT4-fs error (device sda): ext4_mb_generate_buddy:758: group 3s
> [   12.911154] JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 0). T.
>
> Error happens immediately removing the files, which is created in the
> first time.
>
> Thanks
>
>
> On Sun, Jun 12, 2016 at 11:23 AM, Zhangfei Gao <zhangfei.gao@gmail.com> wrote:
>> Here is one question about testing virtio-scsi & vhost-scsi.
>> I met ext4 error using fileio or iblock.
>> And after the error, the filesystem can not be remount next time in
>> guest os except mkfs.ext4 again.
>>
>> Any suggestions?
>> Thanks in advance.
>>
>>
>> Basic steps.
>> fileio:
>> mount /dev/sda3 /mnt
>> dd if=/dev/zero of=test bs=1M count=1024
>>
>>
>> #targetcli
>>
>> (targetcli) /> cd backstores/fileio
>>
>> (targetcli) /> create name=file_backend file_or_dev=/mnt/test size=1G
>>
>> (targetcli) /> cd /vhost
>>
>> (targetcli) /> create wwn=naa.60014052cc816bf4
>>
>> (targetcli) /> cd naa.60014052cc816bf4/tpgt1/luns
>>
>> (targetcli) /> create /backstores/fileio/file_backend
>>
>> (targetcli) /> cd /
>>
>> (targetcli) /> saveconfig
>>
>> (targetcli) /> exit
>>
>> qemu.git/aarch64-softmmu/qemu-system-aarch64 \
>>
>>    -enable-kvm -nographic -kernel Image \
>>
>>    -device vhost-scsi-pci,wwpn=naa.60014052cc816bf4 \
>>
>>    -m 512 -M virt -cpu host \
>>
>>    -append "earlyprintk console=ttyAMA0 mem=512M rw"
>>
>>
>> After guest kernel is boot,
>>
>> Mkfs.ext4 /dev/sda
>>
>> Mount /dev/sda /mnt
>>
>>
>> sync; date; dd if=/dev/zero of=test bs=1M count=100; sync; date;
>>
>>
>> Ext4 error:
>>
>> And can not be mounted next time.
>>
>> [  762.387457] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [  762.395622] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [  762.403915] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [  762.412263] EXT4-fs error (device sda) in ext4_ext_truncate:4661:
>> Corrupt filesystem
>>
>> [  762.420613] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [  762.428913] EXT4-fs error (device sda) in ext4_orphan_del:2896:
>> Corrupt filesystem
>>
>> [  762.437262] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [  762.445614] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [  762.454516] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [  762.462283] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [  767.370571] jbd2_journal_bmap: journal block not found at offset 13 on sda-8
>>
>> [  767.371458] Aborting journal on device sda-8.
>>
>> [  767.395583] EXT4-fs error: 564 callbacks suppressed
>>
>> [  767.396173] EXT4-fs error (device sda) in ext4_da_write_end:2841: IO failure
>>
>> [  767.412221] EXT4-fs error (device sda):
>> ext4_journal_check_start:56: Detected aborted journal
>>
>> [  767.413325] EXT4-fs (sda): Remounting filesystem read-only
>>
>> dd: writing '/mnt/test.bin': Read-only file system
>>
>>
>> blockio:
>>
>> # targetcli
>>
>> /> cd backstores/iblock
>>
>> /backstores/iblock> create name=block_backend dev=/dev/sda4
>>
>> /backstores/iblock> cd /vhost
>>
>> /vhost> create
>>
>> /vhost> ls
>>
>> o- vhost ............................................................ [1 Target]
>>
>>  o- naa.60014053c5cc00ac .............................................. [1 TPG]
>>
>>    o- tpg1 ............................................. [naa.6001405830beacfa]
>>
>>      o- luns ......................................................... [0 LUNs]
>>
>> /vhost> cd naa.60014053c5cc00ac/tpg1/luns
>>
>> /vhost/naa.60...0ac/tpg1/luns> create /backstores/iblock/block_backend
>>
>> /vhost/naa.60...0ac/tpg1/luns> cd /
>>
>> /> saveconfig
>>
>> qemu.git/aarch64-softmmu/qemu-system-aarch64 \
>>
>>    -enable-kvm -nographic -kernel Image \
>>
>>    -device vhost-scsi-pci,wwpn=naa.60014053c5cc00ac \
>>
>>    -m 512 -M virt -cpu host \
>>
>>    -append "earlyprintk console=ttyAMA0 mem=512M"
>>
>>
>> Mount /dev/sda /mnt
>>
>> sync; date; dd if=/dev/zero of=/mnt/test bs=1M count=100; sync; date;
>>
>>
>> sync; date; sync; date; dd if=/dev/zero of=/mnt/test bs=1M count=100;
>>
>> Thu Jan  1 00:01:16 UTC 1970
>>
>> [   77.044879] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [   77.067334] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [   77.075623] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [   77.083970] EXT4-fs error (device sda) in ext4_ext_truncate:4661:
>> Corrupt filesystem
>>
>> [   77.092322] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [   77.100619] EXT4-fs error (device sda) in ext4_orphan_del:2896:
>> Corrupt filesystem
>>
>> [   77.108971] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [   77.117321] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [   77.126204] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>> [   77.133989] EXT4-fs error (device sda) in
>> ext4_reserve_inode_write:5172: Corrupt filesystem
>>
>>
>> [   82.025630] jbd2_journal_bmap: journal block not found at offset 10 on sda-8
>>
>> [   82.026522] Aborting journal on device sda-8.
>>
>> [   82.050642] EXT4-fs error: 563 callbacks suppressed
>>
>> [   82.051278] EXT4-fs error (device sda) in ext4_da_write_end:2841: IO failure
>>
>> [   82.067283] EXT4-fs error (device sda):
>> ext4_journal_check_start:56: Detected aborted journal
>>
>> [   82.068372] EXT4-fs (sda): Remounting filesystem read-only
>>
>> dd: writing '/mnt/test': Read-only file system
