From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Fri, 25 Jul 2014 12:13:12 +0400
Message-ID: <20140725081312.GO6397@azat>
References: <53CBA75B.2030102@fnarfbargle.com>
 <53CC66DA.2080804@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:41323 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaGYIN0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 04:13:26 -0400
Received: by mail-la0-f52.google.com with SMTP id e16so2743781lan.39
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2014 01:13:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <53CC66DA.2080804@fnarfbargle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 21, 2014 at 09:03:22AM +0800, Brad Campbell wrote:
> On 20/07/14 19:26, Brad Campbell wrote:
> >G'day all,
> >
> >Machine was running 3.13.5. x86_64.
> >
> >I had a 12 device (2TB) RAID-6 formatted ext4. I added 2 drives to its
> >underlying md and restriped it (no issues). After the restripe I
> >attempted an online resize using ext2progs 1.42.5 (Debian stable). This
> >failed with a message about the size not fitting into 32 bits so I
> >compiled 1.42.11 and tried again.
> 
> 
> More info:
> I discovered the debug flags, so this is resize2fs -f 255 /dev/md0
> 
> last_start just keeps incrementing for as long as I care to leave it run.
> 
> fs has 4007207 inodes, 1957 groups required.
> fs requires 4374122900 data blocks.
> With 1957 group(s), we have 63820826 blocks available.
> Added 131540 extra group(s), blks_needed 4374122900, data_blocks 62023030,
> last_start 4356599580
> Added 131595 extra group(s), blks_needed 4374122900, data_blocks 73483100,
> last_start 5781212288
> Added 131246 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781244926
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781277564
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781310202
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781342840
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781375478
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781408116
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781440754
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781473392
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781506030
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781538668
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781571306
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781603944
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781636582
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781669220
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781701858
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781734496
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781767134
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781799772
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781832410
> Added 131072 extra group(s), blks_needed 4374122900, data_blocks 79184732,
> last_start 5781865048

blocks_per_group=32768 (u32)
extra_groups=131072 (u32)
b*e=4294967296 # overflow

Could you try attached patched? (I will add appropriate message letter)
It is totally untested and shouldn't break anything, *but* I strongly
recommend you to have a backup before running it.
You could also wait until somebody else review it.

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index a8af969..98ce10a 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2479,7 +2479,8 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
                extra_grps = ext2fs_div64_ceil(remainder,
                                               EXT2_BLOCKS_PER_GROUP(fs->super));
 
-               data_blocks += extra_grps * EXT2_BLOCKS_PER_GROUP(fs->super);
+               data_blocks += (unsigned long long)extra_grps *
+                       EXT2_BLOCKS_PER_GROUP(fs->super);
 
                /* ok we have to account for the last group */
                overhead = calc_group_overhead(fs, groups-1, old_desc_blocks);


-- 
Respectfully
Azat Khuzhin
