From: Dave Chinner <david@fromorbit.com>
Subject: Re: ext4 performance regression 2.6.27-stable versus 2.6.32 and
 later
Date: Fri, 30 Jul 2010 09:28:56 +1000
Message-ID: <20100729232856.GP655@dastard>
References: <4C508A54.7070002@uni-konstanz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Karsten Schaefer <karsten.schaefer@uni-konstanz.de>
To: Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C508A54.7070002@uni-konstanz.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 28, 2010 at 09:51:48PM +0200, Kay Diederichs wrote:
> Dear all,
> 
> we reproducibly find significantly worse ext4 performance when our
> fileservers run 2.6.32 or later kernels, when compared to the
> 2.6.27-stable series.
> 
> The hardware is RAID5 of 5 1TB WD10EACS disks (giving almost 4TB) in an
> external eSATA enclosure (STARDOM ST6600); disks are not partitioned but
> rather the complete disks are used:
> md5 : active raid5 sde[0] sdg[5] sdd[3] sdc[2] sdf[1]
>     3907045376 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5]
> [UUUUU]
> 
> The enclosure is connected using a Silicon Image (supported by
> sata_sil24) PCIe-X1 adapter to one of our fileservers (either the backup
> fileserver, 32bit desktop hardware with Intel(R) Pentium(R) D CPU
> 3.40GHz, or a production-fileserver 64bit Precision WorkStation 670 w/ 2
> Xeon 3.2GHz).
> 
> The ext4 filesystem was created using
> mke2fs -j -T largefile -E stride=128,stripe_width=512 -O extent,uninit_bg
> It is mounted with noatime,data=writeback
> 
> As operating system we usually use RHEL5.5, but to exclude problems with
> self-compiled kernels, we also booted USB sticks with latest Fedora12
> and FC13 .
> 
> Our benchmarks consist of copying 100 6MB files from and to the RAID5,
> over NFS (NVSv3, GB ethernet, TCP, async export), and tar-ing and
> rsync-ing kernel trees back and forth. Before and after each individual
> benchmark part, we "sync" and "echo 3 > /proc/sys/vm/drop_caches" on
> both the client and the server.
> 
> The problem:
> with 2.6.27.48 we typically get:
>  44 seconds for preparations
>  23 seconds to rsync 100 frames with 597M from nfs directory
>  33 seconds to rsync 100 frames with 595M to nfs directory
>  50 seconds to untar 24353 kernel files with 323M to nfs directory
>  56 seconds to rsync 24353 kernel files with 323M from nfs directory
>  67 seconds to run xds_par in nfs directory (reads and writes 600M)
> 301 seconds to run the script
> 
> with 2.6.32.16 we find:
>  49 seconds for preparations
>  23 seconds to rsync 100 frames with 597M from nfs directory
> 261 seconds to rsync 100 frames with 595M to nfs directory
>  74 seconds to untar 24353 kernel files with 323M to nfs directory
>  67 seconds to rsync 24353 kernel files with 323M from nfs directory
> 290 seconds to run xds_par in nfs directory (reads and writes 600M)
> 797 seconds to run the script
> 
> This is quite reproducible (times varying about 1-2% or so). All times
> include reading and writing on the client side (stock CentOS5.5 Nehalem
> machines with fast single SATA disks). The 2.6.32.16 times are the same
> with FC12 and FC13 (booted from USB stick).
> 
> The 2.6.27-versus-2.6.32+ regression cannot be due to barriers because
> md RAID5 does not support barriers ("JBD: barrier-based sync failed on
> md5 - disabling barriers").
> 
> What we tried: noop and deadline schedulers instead of cfq;
> modifications of /sys/block/sd[c-g]/queue/max_sectors_kb; switching
> on/off NCQ; blockdev --setra 8192 /dev/md5; increasing
> /sys/block/md5/md/stripe_cache_size
> 
> When looking at the I/O statistics while the benchmark is running, we
> see very choppy patterns for 2.6.32, but quite smooth stats for
> 2.6.27-stable.
> 
> It is not an NFS problem; we see the same effect when transferring the
> data using an rsync daemon. We believe, but are not sure, that the
> problem does not exist with ext3 - it's not so quick to re-format a 4 TB
> volume.
> 
> Any ideas? We cannot believe that a general ext4 regression should have
> gone unnoticed. So is it due to the interaction of ext4 with md-RAID5 ?

Try reverting 50797481a7bdee548589506d7d7b48b08bc14dcd (ext4: Avoid
group preallocation for closed files). IIRC it caused the same sort
of isevere performance regressions for postmark....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
