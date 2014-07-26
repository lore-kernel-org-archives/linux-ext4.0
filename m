From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Sat, 26 Jul 2014 11:45:58 +0400
Message-ID: <20140726074558.GC24045@azat>
References: <53CBA75B.2030102@fnarfbargle.com>
 <53CC66DA.2080804@fnarfbargle.com>
 <20140725081312.GO6397@azat>
 <53D24307.6050903@fnarfbargle.com>
 <20140725140715.GR1865@thunk.org>
 <53D320F6.40809@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64781 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaGZHqC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2014 03:46:02 -0400
Received: by mail-lb0-f181.google.com with SMTP id 10so4006539lbg.40
        for <linux-ext4@vger.kernel.org>; Sat, 26 Jul 2014 00:46:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <53D320F6.40809@fnarfbargle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 11:31:02AM +0800, Brad Campbell wrote:
> On 25/07/14 22:07, Theodore Ts'o wrote:
> >On Fri, Jul 25, 2014 at 07:44:07PM +0800, Brad Campbell wrote:
> >>
> >>Appreciate you taking a look at this and I see where you are going with it.
> >
> >This patch looks good to me.  If you could give it a try, I would
> >appreciate it.
> >
> >This looks like the same bug which was reported in Ubuntu:
> >
> >https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/1321958
> 
> 
> The patch would not apply automatically to 1.42.11 but was easy enough to
> apply by hand.
> 
> root@srv:~/src/e2fsprogs/e2fsprogs-1.42.11/resize# ./resize2fs -d 255
> /dev/md0
> resize2fs 1.42.11 (09-Jul-2014)
> fs has 4007207 inodes, 1957 groups required.
> fs requires 4374122900 data blocks.
> With 1957 group(s), we have 63820826 blocks available.
> Added 131540 extra group(s), blks_needed 4374122900, data_blocks 4356990326,
> last_start 4356599580
> Added 523 extra group(s), blks_needed 4374122900, data_blocks 4374059350,
> last_start 4373440788
> Added 2 extra group(s), blks_needed 4374122900, data_blocks 4374124886,
> last_start 4373473426
> Last group's overhead is 1430
> Need 649474 data blocks in last group
> Final size of last group is 650904
> Estimated blocks needed: 4391437088
> Extents safety margin: 2826959
> Filesystem at /dev/md0 is mounted on /server; on-line resizing required
> old_desc_blocks = 2768, new_desc_blocks = 2795
> ./resize2fs: Invalid argument While checking for on-line resizing support
> 
> [489412.650430] EXT4-fs (md0): resizing filesystem from 5804916736 to
> 5860149888 blocks
> [489412.700282] EXT4-fs warning (device md0): verify_reserved_gdb:713:
> reserved GDT 2769 missing grp 177147 (5804755665)
> [489412.739676] EXT4-fs (md0): resized filesystem to 5860149888
> [489413.215230] EXT4-fs warning (device md0): ext4_group_extend:1720: can't
> shrink FS - resize aborted

And I guess that attached patch can fix the online resizing issue.
Ted, could you take a look?

Thanks.
Azat.

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index bb0e80f..38f7ced 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1928,7 +1928,8 @@ retry:
                        n_desc_blocks = o_desc_blocks +
                                le16_to_cpu(es->s_reserved_gdt_blocks);
                        n_group = n_desc_blocks * EXT4_DESC_PER_BLOCK(sb);
-                       n_blocks_count = n_group * EXT4_BLOCKS_PER_GROUP(sb);
+                       n_blocks_count = (ext4_fsblk_t)n_group *
+                               EXT4_BLOCKS_PER_GROUP(sb);
                        n_group--; /* set to last group number */
                }

