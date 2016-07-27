From: Zhangfei Gao <zhangfei.gao@gmail.com>
Subject: Re: ext4 error when testing virtio-scsi & vhost-scsi
Date: Wed, 27 Jul 2016 15:58:55 +0800
Message-ID: <CAMj5BkifLL=3C5f0VZKhpNmi81em8P5VNupr7d7_aD=uo2Hwow@mail.gmail.com>
References: <CAMj5BkiVGQ4dAUY+wi-+O4qRdVS6YPiUP2BpsiE5y0r+2AhLgw@mail.gmail.com>
 <CAMj5BkiKC2m3PLHvoDWwyj9BQZ-Bg5mD0f1J0kZcpwroH+rR1g@mail.gmail.com>
 <CAMj5BkgSXjD+_GB_VPgizowyyJ1uYxLiKd7ehQmEdVvnuY55cA@mail.gmail.com>
 <20160712164324.GC11020@thunk.org> <CAMj5BkgTycMbfQpUVAV17ahYT1sGm6w3YDtpz0E--vN=tF55xA@mail.gmail.com>
 <CAMj5BkicJhB1Bk6q_ZT_nMKSPWf1XEGchtnGnMPFy=O_0x91hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org,
	target-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Nicholas Bellinger <nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAMj5BkicJhB1Bk6q_ZT_nMKSPWf1XEGchtnGnMPFy=O_0x91hA@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, Michael

I have met ext4 error when using vhost_scsi on arm64 platform, and
suspect it is vhost_scsi issue.

Ext4 error when testing virtio_scsi & vhost_scsi


No issue:
1. virtio_scsi, ext4
2. vhost_scsi & virtio_scsi, ext2
3.  Instead of vhost, also tried loopback and no problem.
Using loopback, host can use the new block device, while vhost is used
by guest (qemu).
http://www.linux-iscsi.org/wiki/Tcm_loop
Test directly in host, not find ext4 error.



Have issue:
1. vhost_scsi & virtio_scsi, ext4
a. iblock
b, fileio, file located in /tmp (ram), no device based.

2, Have tried 4.7-r2 and 4.5-rc1 on D02 board, both have issue.
Since I need kvm specific patch for D02, so it may not freely to switch
to older version.

3. Also test with ext4, disabling journal
mkfs.ext4 -O ^has_journal /dev/sda


Do you have any suggestion?

Thanks

On Tue, Jul 19, 2016 at 4:21 PM, Zhangfei Gao <zhangfei.gao@gmail.com> wrote:
> On Tue, Jul 19, 2016 at 3:56 PM, Zhangfei Gao <zhangfei.gao@gmail.com> wrote:
>> Dear Ted
>>
>> On Wed, Jul 13, 2016 at 12:43 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>> On Tue, Jul 12, 2016 at 03:14:38PM +0800, Zhangfei Gao wrote:
>>>> Some update:
>>>>
>>>> If test with ext2, no problem in iblock.
>>>> If test with ext4, ext4_mb_generate_buddy reported error in the
>>>> removing files after reboot.
>>>>
>>>>
>>>> root@(none)$ rm test
>>>> [   21.006549] EXT4-fs error (device sda): ext4_mb_generate_buddy:758: group 18
>>>> , block bitmap and bg descriptor inconsistent: 26464 vs 25600 free clusters
>>>> [   21.008249] JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 0). Th
>>>> ere's a risk of filesystem corruption in case of system crash.
>>>>
>>>> Any special notes of using ext4 in qemu?
>>>
>>> Ext4 has more runtime consistency checking than ext2.  So just because
>>> ext4 complains doesn't mean that there isn't a problem with the file
>>> system; it just means that ext4 is more likely to notice before you
>>> lose user data.
>>>
>>> So if you test with ext2, try running e2fsck afterwards, to make sure
>>> the file system is consistent.
>>>
>>> Given that I'm reguarly testing ext4 using kvm, and I haven't seen
>>> anything like this in a very long time, I suspect the problemb is with
>>> your SCSI code, and not with ext4.
>>>
>>
>> Do you know what's the possible reason of this error.
>>
>> Have tried 4.7-rc2, same issue exist.
>> It can be reproduced by fileio and iblock as backstore.
>> It is easier to happen in qemu like this process:
>> qemu-> mount-> dd xx -> umout -> mount -> rm xx, then the error may
>> happen, no need to reboot.
>>
>> ramdisk can not cause error just because it just malloc and memcpy,
>> while not going to blk layer.
>>
>> Also tried creating one file in /tmp, used as fileio, also can reproduce.
>> So no real device is based.
>>
>> like:
>> cd /tmp
>> dd if=/dev/zero of=test bs=1M count=1024; sync;
>> targetcli
>> #targetcli
>> (targetcli) /> cd backstores/fileio
>> (targetcli) /> create name=file_backend file_or_dev=/tmp/test size=1G
>> (targetcli) /> cd /vhost
>> (targetcli) /> create wwn=naa.60014052cc816bf4
>> (targetcli) /> cd naa.60014052cc816bf4/tpgt1/luns
>> (targetcli) /> create /backstores/fileio/file_backend
>> (targetcli) /> cd /
>> (targetcli) /> saveconfig
>> (targetcli) /> exit
>>
>> /work/qemu.git/aarch64-softmmu/qemu-system-aarch64 \
>>     -enable-kvm -nographic -kernel Image \
>>     -device vhost-scsi-pci,wwpn=naa.60014052cc816bf4 \
>>     -m 512 -M virt -cpu host \
>>     -append "earlyprintk console=ttyAMA0 mem=512M"
>>
>> in qemu:
>> mkfs.ext4 /dev/sda
>> mount /dev/sda /mnt/
>> sync; date; dd if=/dev/zero of=/mnt/test bs=1M count=100; sync; date;
>>
>> using dd test, then some error happen.
>> log like:
>> oot@(none)$ sync; date; dd if=/dev/zero of=test bs=1M count=100; sync;; date;
>> [ 1789.917963] sbc_parse_cdb cdb[0]=0x35
>> [ 1789.922000] fd_execute_sync_cache immed=0
>> Tue Jul 19 07:26:12 UTC 2016
>> [  200.712879] EXT4-fs error (device sda) [ 1790.191770] sbc_parse_cdb
>> cdb[0]=0x2a
>> in ext4_reserve_inode_write:5362[ 1790.198382]  fd_execute_rw
>> : Corrupt filesystem
>> [  200.729001] EXT4-fs error (device sda) [ 1790.207843] sbc_parse_cdb
>> cdb[0]=0x2a
>> in ext4_reserve_inode_write:5362[ 1790.214495]  fd_execute_rw
>> : Corrupt filesystem
>>
>> Looks like the error usually happens after SYCHRONIZE CACHE, but not
>> for sure it is always happen after sync cache.
>>
> It is not always happen after SYCHRONIZE CACHE
>
> Just tried in qemu: mount-> dd xx -> umount -> mount -> rm xx
> ram based, (/tmp/test), no reboot.
>
> root@(none)$ cd /mnt
> root@(none)$ ls
> [  301.444966]  sbc_parse_cdb cdb[0]=0x28
> [  301.449003]  fd_execute_rw
> lost+found  test
> root@(none)$ rm test
> [  304.281920]  sbc_parse_cdb cdb[0]=0x28
> [  304.285955]  fd_execute_rw
> [  118.002338] EXT4-fs error (device sda):[  304.290685] gzf sbc_parse_cdb cdb[0
> ]=0x28
>  ext4_mb_generate_buddy:758: gro[  304.296737] gzf fd_execute_rw
> up 3, block bitmap and bg descri[  304.304099]  sbc_parse_cdb cdb[0]=0x28
> ptor inconsistent: 21504 vs 2143[  304.309322]  fd_execute_rw
> 9 free clusters
> [  118.015903] JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 0). The
> re's a risk of filesystem corruption in case of system crash.
> root@(none)$
>
> Thanks
