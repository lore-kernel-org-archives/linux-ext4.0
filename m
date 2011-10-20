From: Tao Ma <tm@tao.ma>
Subject: Re: ext4_ext_insert_index error
Date: Thu, 20 Oct 2011 09:53:34 +0800
Message-ID: <4E9F7F1E.8070809@tao.ma>
References: <20111020012353.GA8653@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:43006 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752146Ab1JTBxi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2011 21:53:38 -0400
In-Reply-To: <20111020012353.GA8653@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Fengguang,
	sorry for the trouble.
On 10/20/2011 09:23 AM, Wu Fengguang wrote:
> Hi,
> 
> I got these errors when switch the kernel from 3.1-rc8 to linux-next.  Commit
> 4fd30c0330ba951 looks most likely the culprit in the linux-next change set.
This should be already fixed in Ted's tree. Please check whether the fix
works.
http://comments.gmane.org/gmane.comp.file-systems.ext4/28575

Thanks
Tao

> 
> [  301.322279] EXT4-fs error (device sda7): ext4_ext_insert_index:783: inode #12: comm flush-8:0: ix > EXT_LAST_INDEX!
> [  301.322401] EXT4-fs (sda7): delayed block allocation failed for inode 12 at logical offset 3370008 with max blocks 2 with error -5
> [  301.322403] EXT4-fs (sda7): This should not happen!! Data will be lost
> [  301.322404]
> [  301.322580] EXT4-fs error (device sda7): ext4_ext_insert_index:783: inode #12: comm flush-8:0: ix > EXT_LAST_INDEX!
> [  301.322702] EXT4-fs (sda7): delayed block allocation failed for inode 12 at logical offset 3370010 with max blocks 5 with error -5
> [  301.322704] EXT4-fs (sda7): This should not happen!! Data will be lost
> [  301.322705]
> [  301.322885] EXT4-fs error (device sda7): ext4_ext_insert_index:783: inode #12: comm flush-8:0: ix > EXT_LAST_INDEX!
> [  301.323006] EXT4-fs (sda7): delayed block allocation failed for inode 12 at logical offset 3370015 with max blocks 3 with error -5
> [  301.323008] EXT4-fs (sda7): This should not happen!! Data will be lost
> [  301.323010]
> [  301.323414] EXT4-fs error (device sda7): ext4_ext_insert_index:783: inode #13: comm flush-8:0: ix > EXT_LAST_INDEX!
> [  301.323489] EXT4-fs (sda7): delayed block allocation failed for inode 13 at logical offset 3417483 with max blocks 1461 with error -5
> [  301.323490] EXT4-fs (sda7): This should not happen!! Data will be lost
> [  301.323491]
> [  301.366611] EXT4-fs error (device sda7): ext4_ext_insert_index:783: inode #12: comm flush-8:0: ix > EXT_LAST_INDEX!
> [  301.366694] EXT4-fs (sda7): delayed block allocation failed for inode 12 at logical offset 3370018 with max blocks 344 with error -5
> [  301.366696] EXT4-fs (sda7): This should not happen!! Data will be lost
> [  301.366696]
> [  301.367028] EXT4-fs error (device sda7): ext4_ext_insert_index:783: inode #12: comm flush-8:0: ix > EXT_LAST_INDEX!
> [  301.367117] EXT4-fs (sda7): delayed block allocation failed for inode 12 at logical offset 3370362 with max blocks 13 with error -5
> [  301.367118] EXT4-fs (sda7): This should not happen!! Data will be lost
> [  301.367119]
> [  301.367257] EXT4-fs error (device sda7): ext4_ext_insert_index:783: inode #12: comm flush-8:0: ix > EXT_LAST_INDEX!
> [  301.367341] EXT4-fs (sda7): delayed block allocation failed for inode 12 at logical offset 3370375 with max blocks 3 with error -5
> [  301.367342] EXT4-fs (sda7): This should not happen!! Data will be lost
> [  301.367343]
> [  301.367487] EXT4-fs error (device sda7): ext4_ext_insert_index:783: inode #12: comm flush-8:0: ix > EXT_LAST_INDEX!
> [  301.367606] EXT4-fs (sda7): delayed block allocation failed for inode 12 at logical offset 3370378 with max blocks 2 with error -5
> [  301.367609] EXT4-fs (sda7): This should not happen!! Data will be lost
> 
> It all starts when comparing the below kernels' performance. I noticed
> two outstanding regressions in the dirty_thresh=1M,8M cases of ext4.
> The two cases with regressions are both running 2 sequential write dd's.
> 
>      3.1.0-rc8-ioless6a+  3.1.0-rc9-ioless-full-next-20111014+  
> ------------------------  ------------------------  
>                    58.23        -3.0%        56.47  thresh=100M/btrfs-10dd-4k-8p-4096M-100M:10-X
>                    58.43        -3.7%        56.28  thresh=100M/btrfs-1dd-4k-8p-4096M-100M:10-X
>                    58.53        -4.1%        56.11  thresh=100M/btrfs-2dd-4k-8p-4096M-100M:10-X
>                    37.34        +1.4%        37.86  thresh=100M/ext3-10dd-4k-8p-4096M-100M:10-X
>                    44.44        +3.3%        45.91  thresh=100M/ext3-1dd-4k-8p-4096M-100M:10-X
>                    41.70        +0.4%        41.87  thresh=100M/ext3-2dd-4k-8p-4096M-100M:10-X
>                    46.45        -1.7%        45.68  thresh=100M/ext4-10dd-4k-8p-4096M-100M:10-X
>                    56.60        -1.5%        55.74  thresh=100M/ext4-1dd-4k-8p-4096M-100M:10-X
>                    54.14        -1.5%        53.32  thresh=100M/ext4-2dd-4k-8p-4096M-100M:10-X
>                    44.53        +3.8%        46.20  thresh=100M/xfs-10dd-4k-8p-4096M-100M:10-X
>                    55.89        -0.3%        55.72  thresh=100M/xfs-1dd-4k-8p-4096M-100M:10-X
>                    51.11        +5.7%        54.01  thresh=100M/xfs-2dd-4k-8p-4096M-100M:10-X
>                    56.55        -2.6%        55.08  thresh=1G/btrfs-100dd-4k-8p-4096M-1024M:10-X
>                    56.11        -1.1%        55.49  thresh=1G/btrfs-10dd-4k-8p-4096M-1024M:10-X
>                    56.21        -1.5%        55.38  thresh=1G/btrfs-1dd-4k-8p-4096M-1024M:10-X
>                    30.66       +19.7%        36.70  thresh=1G/ext3-100dd-4k-8p-4096M-1024M:10-X
>                    35.24       +15.3%        40.64  thresh=1G/ext3-10dd-4k-8p-4096M-1024M:10-X
>                    43.58       +11.6%        48.65  thresh=1G/ext3-1dd-4k-8p-4096M-1024M:10-X
>                    50.42        -1.2%        49.84  thresh=1G/ext4-100dd-4k-8p-4096M-1024M:10-X
>                    56.23        -0.4%        56.03  thresh=1G/ext4-10dd-4k-8p-4096M-1024M:10-X
>                    58.12        -1.2%        57.42  thresh=1G/ext4-1dd-4k-8p-4096M-1024M:10-X
>                    41.76        +9.5%        45.74  thresh=1G/xfs-100dd-4k-8p-4096M-1024M:10-X
>                    48.34       +12.1%        54.19  thresh=1G/xfs-10dd-4k-8p-4096M-1024M:10-X
>                    52.36        +6.8%        55.93  thresh=1G/xfs-1dd-4k-8p-4096M-1024M:10-X
>                    32.09        -0.8%        31.82  thresh=1M/ext4-10dd-4k-8p-4096M-1M:10-X
>                    51.36        +1.9%        52.33  thresh=1M/ext4-1dd-4k-8p-4096M-1M:10-X
> ==>                46.93       -59.4%        19.05  thresh=1M/ext4-2dd-4k-8p-4096M-1M:10-X
>                    28.68        -0.9%        28.43  thresh=1M/xfs-10dd-4k-8p-4096M-1M:10-X
>                    51.95        +1.9%        52.93  thresh=1M/xfs-1dd-4k-8p-4096M-1M:10-X
>                    47.07        -0.4%        46.87  thresh=1M/xfs-2dd-4k-8p-4096M-1M:10-X
>                    54.37        +0.3%        54.54  thresh=8M/btrfs-10dd-4k-8p-4096M-8M:10-X
>                    56.12        +0.9%        56.60  thresh=8M/btrfs-1dd-4k-8p-4096M-8M:10-X
>                    56.22        -0.0%        56.21  thresh=8M/btrfs-2dd-4k-8p-4096M-8M:10-X
>                    32.21        +1.0%        32.54  thresh=8M/ext3-10dd-4k-8p-4096M-8M:10-X
>                    45.37        +1.4%        46.01  thresh=8M/ext3-1dd-4k-8p-4096M-8M:10-X
>                    43.71        +1.0%        44.13  thresh=8M/ext3-2dd-4k-8p-4096M-8M:10-X
>                    35.58        +0.5%        35.78  thresh=8M/ext4-10dd-4k-8p-4096M-8M:10-X
>                    56.39        -1.9%        55.29  thresh=8M/ext4-1dd-4k-8p-4096M-8M:10-X
> ==>                51.26       -63.2%        18.85  thresh=8M/ext4-2dd-4k-8p-4096M-8M:10-X
>                    31.07        +0.5%        31.21  thresh=8M/xfs-10dd-4k-8p-4096M-8M:10-X
>                    55.44        -2.4%        54.10  thresh=8M/xfs-1dd-4k-8p-4096M-8M:10-X
>                    47.59        -1.3%        46.97  thresh=8M/xfs-2dd-4k-8p-4096M-8M:10-X
>                  2016.38        -1.8%      1979.91  TOTAL write_bw
> 
> It's not likely media error because the other cases work fine. And
> grep shows that the error messages only show up in these two cases:
> 
> wfg@bee /export/writeback% grep -l ext4_ext_insert_index thresh*/*-ioless6*+/dmesg
> wfg@bee /export/writeback% grep -l ext4_ext_insert_index thresh*/*-ioless-full-next-20111014+/dmesg
> thresh=1M/ext4-2dd-4k-8p-2941M-1M:10-3.1.0-rc9-ioless-full-next-20111014+/dmesg
> thresh=8M/ext4-2dd-4k-8p-2941M-8M:10-3.1.0-rc9-ioless-full-next-20111014+/dmesg
> 
> Thanks,
> Fengguang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

