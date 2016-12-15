From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: Big I/O requests are split into small ones due to unaligned ext4
 partition boundary?
Date: Thu, 15 Dec 2016 20:43:07 +0800
Message-ID: <CACVXFVMfuqT6ZoCECaCyhiM1hosZzAjpgv1kibbpqizxKT2f3w@mail.gmail.com>
References: <MWHPR03MB26692343C35CE591E277A816BF9D0@MWHPR03MB2669.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abel Hu <Chou.Hu@microsoft.com>,
        Thomas Shao <huishao@microsoft.com>,
        Matthew Wilcox <matthew@wil.cx>,
        Long Li <longli@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR03MB26692343C35CE591E277A816BF9D0@MWHPR03MB2669.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 15, 2016 at 7:47 PM, Dexuan Cui <decui@microsoft.com> wrote:
> Hi, when I run "mkfs.ext4 /dev/sdc2" in a Linux virtual machine on Hyper-V,
> where a disk IOPS=500 limit is applied by me [0],  the command takes much
> more time, if the ext4 partition boundary is not properly aligned:
>
> Example 1 [1]: it takes ~7 minutes with average wMB/s = 0.3   (slow)
> Example 2 [2]: it takes ~3.5 minutes with average wMB/s = 0.6 (slow)
> Example 3 [3]: it takes ~0.5 minute with average wMB/s = 4 (expected)
>
> strace shows the mkfs.ext3 program calls seek()/write() a lot and most of
> the writes use 32KB buffers (this should be big enough), and the program
> only invokes fsync() once, after it issues all the writes -- the fsync() takes
>>99% of the time.
>
> By logging SCSI commands, the SCSI Write(10) command is used here for the
> userspace 32KB write:
> in example 1, *each* command writes 1 or 2 sectors only (1 sector = 512 bytes);
> in example 2, *each* command writes 2 or 4 sectors only;
> in example 3, each command writes 1024 sectors.
>
> It looks the kernel block I/O layer can somehow split big user-space buffers
> into really small write requests (1, 2, and 4 sectors)?
> This looks really strange to me.
>
> Note: in my test, this strange issue happens to 4.4 and the mainline 4.9 kernels,
> but the stable 3.18.45 kernel doesn't have the issue, i.e. all the 3 above test
> examples can finish in ~0.5 minute.
>
> Any comment?

I remember that we discussed this kind of issue, please see the discussion[1]
and check if the patch[2] can fix your issue.

[1] http://marc.info/?t=145805525500002&r=1&w=2
[2] http://marc.info/?l=linux-kernel&m=145934325429152&w=2


Thanks,
Ming


>
> Thanks!
> -- Dexuan
>
>
> [0] The max IOPS are measured in 8KB increments, meaning the max
>  throughput is 8KB * 500 = 4000KB.
>
> [1] This is the partition info of my 20GB disk:
> # fdisk -l /dev/sdc
> Disk /dev/sdc: 20 GiB, 21474836480 bytes, 41943040 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disklabel type: dos
> Disk identifier: 0x00000000
>
> Device     Boot    Start      End  Sectors  Size Id Type
> /dev/sdc1              1 14281784 14281784  6.8G 82 Linux swap / Solaris
> /dev/sdc2       14281785 41929649 27647865 13.2G 83 Linux
>
> Here, start_sector = 14281785, end_sector = 41929649.
>
> [2] start_sector = 14282752, end_sector = 41929649
>
> [3] start_sector = 14282752, end_sector = 41943039



-- 
Ming Lei
