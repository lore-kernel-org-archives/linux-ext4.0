From: zhuyj <zyjzyj2000@gmail.com>
Subject: Re: a problem about ext4.
Date: Tue, 12 Mar 2013 15:49:10 +0800
Message-ID: <513EDDF6.3040206@gmail.xom>
References: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com> <513EDC2B.9020604@gmail.xom>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: zhuyj <zyjzyj2000@gmail.xom>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43073 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab3CLHtN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Mar 2013 03:49:13 -0400
Received: by mail-pb0-f50.google.com with SMTP id up1so4656326pbc.23
        for <linux-ext4@vger.kernel.org>; Tue, 12 Mar 2013 00:49:12 -0700 (PDT)
In-Reply-To: <513EDC2B.9020604@gmail.xom>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, all

Almost 2.6.3x has this problem. Is it a problem?

Any reply is appreciated.
Zhuyj

On 03/12/2013 03:41 PM, zhuyj wrote:
> Hi, all
>
> I install Ubuntu 11.04 on Dell-Latitude-D630.
> Linux kernel is 2.6.39.4(I compiled)
>
> uname -a
> Linux Dell-Latitude-D630 2.6.39.4-zhuyj26394 #2 SMP Tue Mar 12 
> 13:23:06 CST 2013 i686 i686 i386 GNU/Linux
>
> I followed these steps:
>
> ****************************Begin***************************************
> 1. get ltp-full-20130109.bz2 and run "./configure;make", then we will 
> get fsstress;
>
> 2. mount -t tmpfs -o size=512m tmpfs /tmp
>
> 3. dd if=/dev/zero of=/tmp/img bs=1024 count=$((500*1024))
>
> 4. ls -lah /tmp/img
>
> total 501M
> drwxrwxrwt  2 root root   60 2013-03-12 15:18 .
> drwxr-xr-x 23 root root 4.0K 2013-03-12 13:09 ..
> -rw-r--r--  1 root root 500M 2013-03-12 15:18 img
>
> 5. df
>
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda1            113317544   6994416 100566868   7% /
> none                   1023772       696   1023076   1% /dev
> none                   1030440        80   1030360   1% /dev/shm
> none                   1030440        92   1030348   1% /var/run
> none                   1030440         0   1030440   0% /var/lock
> tmpfs                   524288    512504     11784  98% /tmp
>
> 6. mkfs.ext4 /tmp/img
>
> mke2fs 1.41.14 (22-Dec-2010)
> /tmp/img is not a block special device.
> Proceed anyway? (y,n) y
> Filesystem label=
> OS type: Linux
> Block size=1024 (log=0)
> Fragment size=1024 (log=0)
> Stride=0 blocks, Stripe width=0 blocks
> 128016 inodes, 512000 blocks
> 25600 blocks (5.00%) reserved for the super user
> First data block=1
> Maximum filesystem blocks=67633152
> 63 block groups
> 8192 blocks per group, 8192 fragments per group
> 2032 inodes per group
> Superblock backups stored on blocks:
>     8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
>
> Writing inode tables: done
> Creating journal (8192 blocks): done
> Writing superblocks and filesystem accounting information: done
>
> This filesystem will be automatically checked every 30 mounts or
> 180 days, whichever comes first.  Use tune2fs -c or -i to override.
>
> 7. mkdir /tmp/mnt
>
> 8. mount -t ext4 -o loop /tmp/img /tmp/mnt
>
> 9. df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda1            113317544   6994424 100566860   7% /
> none                   1023772       696   1023076   1% /dev
> none                   1030440        80   1030360   1% /dev/shm
> none                   1030440        92   1030348   1% /var/run
> none                   1030440         0   1030440   0% /var/lock
> tmpfs                   524288    512504     11784  98% /tmp
> /dev/loop0              495844     10510    459734   3% /tmp/mnt
>
> 10. cd /tmp/mnt; mkdir /tmp/mnt/tmp1 /tmp/mnt/tmp2; cp ~/fsstress 
> /tmp/mnt
> ./fsstress -c -p 5 -n 10000 -d . -l 0 -s 10M &
> ./fsstress -c -p 5 -n 10000 -d ./tmp1 -l 0 -s 10M &
> ./fsstress -c -p 5 -n 10000 -d ./tmp2 -l 0 -s 10M &
>
> 11.when the following appears, run "ps;killall fsstress;ps"
> ./tmp1: No such file or directory
> ./tmp2: No such file or directory
>
> [2]-  Exit 1                  ./fsstress -c -p 5 -n 10000 -d ./tmp1 -l 
> 0 -s 10M
> [3]+  Exit 1                  ./fsstress -c -p 5 -n 10000 -d ./tmp2 -l 
> 0 -s 10M
>
> These messages will appear:
>
> ps;killall fsstress;ps
>   PID TTY          TIME CMD
>  1366 pts/0    00:00:01 bash
>  1600 pts/0    00:00:00 fsstress
>  1633 pts/0    00:00:07 fsstress
>  1634 pts/0    00:00:06 fsstress
>  1635 pts/0    00:00:06 fsstress
>  1636 pts/0    00:00:07 fsstress
>  1637 pts/0    00:00:07 fsstress
>  1640 pts/0    00:00:00 ps
> [1]+  Terminated              ./fsstress -c -p 5 -n 10000 -d . -l 0 -s 
> 10M
>   PID TTY          TIME CMD
>  1366 pts/0    00:00:01 bash
>  1642 pts/0    00:00:00 ps
>
> 12. /bin/sync;/bin/echo 1 > /proc/sys/vm/drop_caches
>
> 13. rm -Rf p*;rm -Rf tmp*
>
> rm: cannot remove `p0': Directory not empty
> rm: cannot remove `p1/d99d/d9b4/da40/da71/da74': Directory not empty
> rm: cannot remove `p2/dc/d79/f56f': Input/output error
> rm: cannot remove `p2/dc/d79/f362': Input/output error
> rm: cannot remove `p2/dc/d79/c460': Input/output error
> rm: cannot remove `p2/dc/d79/cf4': Input/output error
> rm: cannot remove `p2/dc/d79/f3b0': Input/output error
> rm: cannot remove `p2/dc/d79/d107/d95e/d7f7/fb50': Input/output error
> rm: cannot remove `p2/dc/d79/d107/d95e/f99e': Input/output error
> rm: cannot remove `p2/dc/d79/d107/d95e/fc40': Input/output error
> rm: cannot remove `p2/dc/d79/d107/f7ab': Input/output error
> rm: cannot remove `p2/dc/d79/d107/d547/c843': Input/output error
> rm: cannot remove `p2/dc/d79/d107/d547/c871': Input/output error
> rm: cannot remove `p2/dc/d79/d107/fa77': Input/output error
> rm: cannot remove `p2/dc/d79/f12e': Input/output error
> rm: cannot remove `p2/dc/d79/c623': Input/output error
> rm: cannot remove `p2/dc/d79/f207': Input/output error
> rm: cannot remove `p2/dc/d79/c216': Input/output error
> rm: cannot remove `p2/dc/d79/f23d': Input/output error
> rm: cannot remove `p2/dc/d79/c250': Input/output error
> rm: cannot remove `p2/dc/d79/f274': Input/output error
> rm: cannot remove `p2/dc/d79/f285': Input/output error
> rm: cannot remove `p2/dc/d79/f2af': Input/output error
> rm: cannot remove `p2/dc/d79/c2d1': Input/output error
> rm: cannot remove `p2/dc/d79/c2ee': Input/output error
> rm: cannot remove `p2/dc/d79/c35a': Input/output error
> .....
>
> 14. run "dmesg"
>
> [  469.002632] EXT4-fs warning (device loop0): dx_probe:364: 
> Unrecognised inode hash code 12
> [  469.002647] EXT4-fs warning (device loop0): dx_probe:472: Corrupt 
> dir inode 8423, running e2fsck is recommended.
> [  469.018830] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8423: comm rm: deleted inode referenced: 8926
> [  469.019792] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8423: comm rm: deleted inode referenced: 8816
> [  469.019950] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8423: comm rm: deleted inode referenced: 8570
> [  469.020729] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8423: comm rm: deleted inode referenced: 7814
> [  469.021227] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8423: comm rm: deleted inode referenced: 9259
> [  469.048610] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #10178: comm rm: deleted inode referenced: 7791
> [  469.049919] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #10177: comm rm: deleted inode referenced: 8100
> [  469.053826] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #10177: comm rm: deleted inode referenced: 8822
> [  469.060481] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8417: comm rm: deleted inode referenced: 8113
> [  469.062336] EXT4-fs warning (device loop0): dx_probe:364: 
> Unrecognised inode hash code 12
> [  469.062349] EXT4-fs warning (device loop0): dx_probe:472: Corrupt 
> dir inode 10163, running e2fsck is recommended.
> [  469.065721] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #10163: comm rm: deleted inode referenced: 9027
> [  469.066138] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #10163: comm rm: deleted inode referenced: 9090
> [  469.067526] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8417: comm rm: deleted inode referenced: 8443
> [  469.068584] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8423: comm rm: deleted inode referenced: 8067
> [  469.069280] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8423: comm rm: deleted inode referenced: 9694
> [  469.069893] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8423: comm rm: deleted inode referenced: 8100
> [  469.070123] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8423: comm rm: deleted inode referenced: 8635
> [  469.070509] EXT4-fs error (device loop0): ext4_lookup:1044: inode 
> #8423: comm rm: deleted inode referenced: 8929
> ......
>
> ***************************End********************************************** 
>
>
> But if I use ext3, this will not occur.
> If I do not run "/bin/sync;/bin/echo 1 > /proc/sys/vm/drop_caches", 
> this will not occur.
> If I use kernel>=3.0, this will not occur.
>
> But I use ext4 and run "/bin/sync; /bin/echo 1 > 
> /proc/sys/vm/drop_caches", these error messages.
>
> So is this is a bug?
>

