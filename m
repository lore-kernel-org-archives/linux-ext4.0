From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: mkfs.ext4 -D option fails to mount
Date: Thu, 29 Jun 2017 09:57:27 -0600
Message-ID: <20170629155727.GA8536@linux.intel.com>
References: <20170629153538.GA4268@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47204 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751685AbdF2P5n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Jun 2017 11:57:43 -0400
Content-Disposition: inline
In-Reply-To: <20170629153538.GA4268@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 29, 2017 at 09:35:38AM -0600, Ross Zwisler wrote:
> Our validation team noticed that in some configurations mkfs.ext4 with the
> -D option creates a filesystem that can't be mounted:
> 
>   # mkfs.ext4 -D -F /dev/pmem5 
>   mke2fs 1.43.3 (04-Sep-2016)
>   /dev/pmem5 contains a ext4 file system
>   	last mounted on Tue Jul 26 07:44:19 2016
>   Creating filesystem with 65027584 4k blocks and 16261120 inodes
>   Filesystem UUID: 6f95ece9-d4cb-4cfc-bc22-211119d5efe7
>   Superblock backups stored on blocks: 
>   	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
>   	4096000, 7962624, 11239424, 20480000, 23887872
>   
>   Allocating group tables: done                            
>   Writing inode tables: done                            
>   Creating journal (262144 blocks): done
>   Writing superblocks and filesystem accounting information: done     
>   
>   # mount /dev/pmem5 /mnt
>   mount: wrong fs type, bad option, bad superblock on /dev/pmem5,
>          missing codepage or helper program, or other error
>   
>          In some cases useful info is found in syslog - try
>          dmesg | tail or so.
> 
> where dmesg says:
> 
>   EXT4-fs (pmem5): ext4_check_descriptors: Block bitmap for group 1 overlaps superblock
>   EXT4-fs (pmem5): ext4_check_descriptors: Inode bitmap for group 1 overlaps superblock
>   EXT4-fs (pmem5): ext4_check_descriptors: Inode table for group 1 overlaps superblock
>   EXT4-fs (pmem5): ext4_check_descriptors: Block bitmap for group 2 overlaps superblock
>   EXT4-fs (pmem5): ext4_check_descriptors: Inode bitmap for group 2 overlaps superblock
>   EXT4-fs (pmem5): ext4_check_descriptors: Inode table for group 2 overlaps superblock
>   ...
>   EXT4-fs (pmem5): ext4_check_descriptors: Block bitmap for group 63 overlaps superblock
>   EXT4-fs (pmem5): ext4_check_descriptors: Inode bitmap for group 63 overlaps superblock
>   EXT4-fs (pmem5): ext4_check_descriptors: Inode table for group 63 overlaps superblock
>   EXT4-fs (pmem5): no journal found
> 
> If we omit the "-D" option from mkfs.ext4, everything works.  Note also that
> this behavior is independent of the DAX mount option.
> 
> This isn't blocking us, I just thought you would want to know.

One more bit of info - this seems to be strongly tied to the size of the
block device.  With a 32 GB block device it works fine, with 248 GB you get
overlap messages for groups 1 through 63, and with a 250 GB device you get
overlaps for groups 1 through 1999.

I've been varying my virtual NVDIMM namespace size via QEMU.
Here's are the relevant bits from my QEMU my command line to enable the
NVDIMM:

-m 8G,slots=3,maxmem=512G -machine pc,accel=kvm,nvdimm
-object memory-backend-file,id=mem1,share,mem-path=/tmp/nvdimm-8,size=250G
-device nvdimm,memdev=mem1,id=nv1

Here's my full QEMU command line, in case that's interesting:

sudo /usr/bin/qemu-system-x86_64 /home/rzwisler/vms/amonkhet-8.qcow2 -m
8G,slots=3,maxmem=512G -smp 6 -machine pc,accel=kvm,nvdimm -enable-kvm -netdev
tap,id=hostnet0,ifname=tap8,script=no,downscript=no -device
virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:48:94:b8,bus=pci.0,addr=0x8
-rtc base=localtime -serial stdio -display none -monitor
unix:/tmp/amonkhet-8.monitor,server,nowait -object
memory-backend-file,id=mem1,share,mem-path=/tmp/nvdimm-8,size=250G -device
nvdimm,memdev=mem1,id=nv1

- Ross
