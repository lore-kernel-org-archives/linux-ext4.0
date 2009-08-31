From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: large file system & high object count testing
Date: Mon, 31 Aug 2009 13:02:24 -0400
Message-ID: <4A9C0220.1040503@redhat.com>
References: <4A9BFB88.5030409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@thunk.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbZHaRAz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2009 13:00:55 -0400
In-Reply-To: <4A9BFB88.5030409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/31/2009 12:34 PM, Ric Wheeler wrote:
>
> We have put together a very large, relatively slow JBOD to test 
> scalability with (big server, 40GB of DRAM, 8 CPU's + 4 SAS expansion 
> shelves, each with 16 2TB WD S-ATA drives).
>
> In all, this is pulled together with DM (striped) to give us a bit 
> over 116TB.
>
> Testing was done on 2.6.31-rc6 along with the pu branches e2fsprogs.
>
> Everything went well until after the fsck - I think that I have 
> reproduced that earlier issue with a failed mount.
>
> mkfs took a very long time - longer than fsck. fsck (with around 500 
> million 20KB files) finished in just under 2 hours.
>
> logs below,
>
> ric


One more note - this file system was filled using fs_mark, but without 
doing any fsync() calls.

The unmount took several minutes (which I did not time), but the 
following was logged during that:

Mount:

Aug 28 23:46:14 megadeth kernel: EXT4-fs (dm-75): barriers enabled
Aug 28 23:46:14 megadeth kernel: EXT4-fs (dm-75): internal journal on 
dm-75:8
Aug 28 23:46:14 megadeth kernel: EXT4-fs (dm-75): delayed allocation enabled
Aug 28 23:46:14 megadeth kernel: EXT4-fs: file extents enabled
Aug 28 23:46:21 megadeth kernel: EXT4-fs: mballoc enabled
Aug 28 23:46:21 megadeth kernel: EXT4-fs (dm-75): mounted filesystem 
with ordered data mode

umount:

Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 2580708130 blocks 
516141626 reqs (511081408 success)
Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 5060218 extents 
scanned, 0 goal hits, 5060218 2^N hits, 0 breaks, 0 lost
Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 85164 generated and 
it took 471527376
Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 2590831616 
preallocated, 10120312 discarded

Mount after fsck:
Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75): 
ext4_check_descriptors: Checksum for group 487 failed (59799!=46827)
Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75): group descriptors 
corrupted!

The MBALLOC messages are a bit worrying - what exactly gets discarded 
during an unmount?

ric

>
>
> [root@megadeth e2fsprogs]# time /sbin/mkfs.ext4 
> /dev/vg_wdc_disks/lv_wdc_disks
> mke2fs 1.41.8 (20-Jul-2009)
> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> 4287627264 inodes, 31138512896 blocks
> 1556925644 blocks (5.00%) reserved for the super user
> First data block=0
> Maximum filesystem blocks=33285996544
> 950272 block groups
> 32768 blocks per group, 32768 fragments per group
> 4512 inodes per group
> Superblock backups stored on blocks:
>     32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 
> 2654208,
>     4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
>     102400000, 214990848, 512000000, 550731776, 644972544, 1934917632,
>     2560000000, 3855122432, 5804752896, 12800000000, 17414258688,
>     26985857024
>
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (32768 blocks): done
> Writing superblocks and filesystem accounting information: done
>
> This filesystem will be automatically checked every 38 mounts or
> 180 days, whichever comes first.  Use tune2fs -c or -i to override.
>
> real    230m6.362s
> user    2m30.844s
> sys    200m1.002s
> [root@megadeth e2fsprogs]# mount /dev/vg_wdc_disks/lv_wdc_disks /test_fs/
> [root@megadeth e2fsprogs]# df -H /test_fs/
> Filesystem             Size   Used  Avail Use% Mounted on
> /dev/mapper/vg_wdc_disks-lv_wdc_disks
>                        127T   256M   121T   1% /test_fs
>
> FSCK time:
>
> [root@megadeth e2fsck]# time ./e2fsck -f -tt 
> /dev/vg_wdc_disks/lv_wdc_disks
> e2fsck 1.41.8 (20-Jul-2009)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 1: Memory used: 1280k/18014398508273796k (1130k/151k), time: 
> 4630.05/780.40/3580.01
> Pass 1: I/O read: 126019MB, write: 0MB, rate: 27.22MB/s
> Pass 2: Checking directory structure
> Pass 2: Memory used: 1280k/18014398508921888k (65k/1216k), time: 
> 1215.10/454.21/705.79
> Pass 2: I/O read: 34221MB, write: 0MB, rate: 28.16MB/s
> Pass 3: Checking directory connectivity
> Peak memory: Memory used: 1280k/18014398509445284k (65k/1216k), time: 
> 5884.30/1263.59/4295.71
> Pass 3A: Memory used: 1280k/18014398509445284k (65k/1216k), time:  
> 0.00/ 0.00/ 0.00
> Pass 3A: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
> Pass 3: Memory used: 1280k/18014398508921888k (56k/1225k), time:  
> 1.49/ 0.33/ 1.14
> Pass 3: I/O read: 1MB, write: 0MB, rate: 0.67MB/s
> Pass 4: Checking reference counts
> Pass 4: Memory used: 1280k/724124k (56k/1225k), time: 91.59/89.70/ 1.88
> Pass 4: I/O read: 0MB, write: 0MB, rate: 0.00MB/s
> Pass 5: Checking group summary information
> Pass 5: Memory used: 312k/200728k (56k/257k), time: 685.24/170.49/73.72
> Pass 5: I/O read: 713MB, write: 0MB, rate: 1.04MB/s
> /dev/vg_wdc_disks/lv_wdc_disks: 516142418/4287627264 files (0.0% 
> non-contiguous), 2859838991/31138512896 blocks
> Memory used: 312k/200728k (56k/257k), time: 6679.27/1541.45/4371.67
> I/O read: 161012MB, write: 1MB, rate: 24.11MB/s
>
> real    112m14.925s
> user    25m41.557s
> sys    73m46.849s
>
>
> REMOUNT:
>
> [root@megadeth e2fsck]# mount  /dev/vg_wdc_disks/lv_wdc_disks /test_fs/
> mount: wrong fs type, bad option, bad superblock on 
> /dev/mapper/vg_wdc_disks-lv_wdc_disks,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>
> [root@megadeth ~]# tail -20 /var/log/messages
> <snip>
> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75): 
> ext4_check_descriptors: Checksum for group 487 failed (59799!=46827)
> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75): group descriptors 
> corrupted!
>
>
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

