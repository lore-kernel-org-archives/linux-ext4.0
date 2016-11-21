From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: [PATCH 1/3] ext4: sanity check the block and cluster size at
 mount time
Date: Mon, 21 Nov 2016 09:46:45 +0200
Message-ID: <141f9598-225e-f1c0-3897-fce5c0a7cd81@kyup.com>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com>
 <20161118042610.13464-1-tytso@mit.edu>
 <955b7ea8-2fb2-a958-bb8a-5b5003668765@kyup.com>
 <20161118175838.q67hqgjdtydnl22f@thunk.org>
 <CAJFSNy62erBHU6vr2ubO0BXLjCK=xOVJWaq+C=X6PYuHTWoNjg@mail.gmail.com>
 <20161119023603.ujqj6r4yudkmu5vg@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161119023603.ujqj6r4yudkmu5vg@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 11/19/2016 04:36 AM, Theodore Ts'o wrote:
> On Sat, Nov 19, 2016 at 01:25:58AM +0200, Nikolay Borisov wrote:
>>> Can you double check your test?
>>
>> I will. And as I said i'm testing 4.9-rc4 from Linus' tree with only
>> those patches applied.
>>
> 
> I just tested v4.9-rc4 with just the critical patch.  See the test-fix
> branch on ext4.git on kernel.org:
> 
> % git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit -2
> * e7d56cc34f5d - (HEAD -> test-fix) ext4: sanity check the block and cluster size at mount time (13 minutes ago)
> * bc33b0ca11e3 - (tag: v4.9-rc4) Linux 4.9-rc4 (13 days ago)
> 
> It's not reproing for me:

So I downloaded the image again and tested and it indeed doesn't reproduce. However, testing with the same image, but downloaded 
couple of days ago I can still reproduce this. The checksums of both images differ though. The freshly downloaded has the same 
checksum as your whereas my earlier download of it doesn't. All of this without 4/4 being applied. 

With patch 4/4 applied I can actually mount my "earlier" image which was causing a crash even with your other patches applied: 


[root@localhost /]# uname -a
Linux localhost 4.9.0-rc4-clouder1 #47 SMP Mon Nov 21 09:28:17 EET 2016 x86_64 x86_64 x86_64 GNU/Linux

[root@localhost /]# md5sum root/OSS-2016-22-image 
0a53a280ed976d7416b5af0fdd543e0f  root/OSS-2016-22-image

mount -o loop root/OSS-2016-22-image root/ovl-mnt/
dmesg
[  125.376228] EXT4-fs (loop0): filesystem is read-only
[  125.376513] EXT4-fs (loop0): ext4_check_descriptors: Inode bitmap for group 0 overlaps superblock
[  125.376768] EXT4-fs (loop0): ext4_check_descriptors: Checksum for group 0 failed (25303!=248)
[  125.377059] EXT4-fs error (device loop0): count_overhead:3199: comm mount: Invalid number of block group descriptor blocks: 842150400
[  125.381546] EXT4-fs (loop0): revision level too high, forcing read-only mode
[  125.381733] [EXT4 FS bs=1024, gc=1, bpg=8192, ipg=16, mo=e800c02c, mo2=0002]
[  125.381889] System zones: 0-842150400
[  125.382656] EXT4-fs (loop0): filesystem is read-only
[  125.382805] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)

[root@localhost /]# losetup -a    
/dev/loop0: [fd00]:9518 (/root/OSS-2016-22-image)

So patch 4/4 is also a good precaution. I'd say the issue is resolved. 

Tested-by: Nikolay Borisov <kernel@kyup.com>



> 
> % kvm-xfstests shell
> Networking disabled.
> [    5.202323] systemd-fsck[1353]: /dev/vda: clean, 10882/65536 files, 73964/262144 blocks
> [    5.645642] systemd-fsck[2397]: /dev/vdg: recovering journal
> [    5.660848] systemd-fsck[2397]: /dev/vdg: clean, 50/65536 files, 12993/262144 blocks
> 
> Debian GNU/Linux 8 kvm-xfstests ttyS0
> 
> kvm-xfstests login: root (automatic login)
> 
> Last login: Fri Nov 18 21:34:51 EST 2016 on ttyS3
> uLinux kvm-xfstests 4.9.0-rc4-00001-ge7d56cc34f5d #66 SMP Fri Nov 18 21:25:00 EST 2016 i686
> 
> The programs included with the Debian GNU/Linux system are free software;
> the exact distribution terms for each program are described in the
> individual files in /usr/share/doc/*/copyright.
> 
> Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
> permitted by applicable law.
> root@kvm-xfstests:~# uname -a
> Linux kvm-xfstests 4.9.0-rc4-00001-ge7d56cc34f5d #66 SMP Fri Nov 18 21:25:00 EST 2016 i686 GNU/Linux
> root@kvm-xfstests:~# dmesg -n 7
> root@kvm-xfstests:~# mount /vdb
> [   13.241090] EXT4-fs (vdb): recovery complete
> [   13.250367] EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts: (null)
> root@kvm-xfstests:~# md5sum /vdb/OSS-2016-23-image 
> f05e467ff6674a6b469a3b86c972dafa  /vdb/OSS-2016-23-image
> root@kvm-xfstests:~# mount -o loop,ro /vdb/OSS-2016-23-image /mnt
> [   36.160416] EXT4-fs (loop0): Unrecognized mount option "" or missing value
> [   36.170298] EXT4-fs (loop0): failed to parse options in superblock: 
> [   36.177737] EXT4-fs: Warning: mounting with data=journal disables delayed allocation and O_DIRECT support!
> [   36.183217] EXT4-fs (loop0): Invalid log block size: 4286906368
> mount: wrong fs type, bad option, bad superblock on /dev/loop0,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> root@kvm-xfstests:~# QEMU: Terminated
> 
> 							- Ted
> 
