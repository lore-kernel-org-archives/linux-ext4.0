From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: ext4: decrement free clusters/inodes counters when block group
 declared bad
Date: Tue, 08 Jul 2014 13:13:08 +0900
Message-ID: <001c01cf9a62$ec76b9b0$c5642d10$@samsung.com>
References: <20140707114424.GA30564@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: 'Dan Carpenter' <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:26998 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaGHENQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2014 00:13:16 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N8D001P0L1WDW00@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 08 Jul 2014 13:13:08 +0900 (KST)
In-reply-to: <20140707114424.GA30564@mwanda>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Hello Namjae Jeon,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch e43bb4e612b4: "ext4: decrement free clusters/inodes
> counters when block group declared bad" from Jun 26, 2014, leads to
> the following Smatch complaint:
> 
Hi Dan.

Thanks for your report!!
I will send the proper patch to fix this issue.


> fs/ext4/ialloc.c:343 ext4_free_inode()
> 	 error: we previously assumed 'gdp' could be null (see line 300)
> 
> fs/ext4/ialloc.c
>    299		gdp = ext4_get_group_desc(sb, block_group, &bh2);
>    300		if (gdp) {
>                     ^^^
> Check for NULL.
> 
>    301			BUFFER_TRACE(bh2, "get_write_access");
>    302			fatal = ext4_journal_get_write_access(handle, bh2);
>    303		}
>    304		ext4_lock_group(sb, block_group);
>    305		cleared = ext4_test_and_clear_bit(bit, bitmap_bh->b_data);
>    306		if (fatal || !cleared) {
>    307			ext4_unlock_group(sb, block_group);
>    308			goto out;
>    309		}
>    310
>    311		count = ext4_free_inodes_count(sb, gdp) + 1;
>    312		ext4_free_inodes_set(sb, gdp, count);
>    313		if (is_directory) {
>    314			count = ext4_used_dirs_count(sb, gdp) - 1;
>    315			ext4_used_dirs_set(sb, gdp, count);
>    316			percpu_counter_dec(&sbi->s_dirs_counter);
>    317		}
>    318		ext4_inode_bitmap_csum_set(sb, block_group, gdp, bitmap_bh,
>    319					   EXT4_INODES_PER_GROUP(sb) / 8);
>    320		ext4_group_desc_csum_set(sb, block_group, gdp);
>    321		ext4_unlock_group(sb, block_group);
>    322
>    323		percpu_counter_inc(&sbi->s_freeinodes_counter);
>    324		if (sbi->s_log_groups_per_flex) {
>    325			ext4_group_t f = ext4_flex_group(sbi, block_group);
>    326
>    327			atomic_inc(&sbi->s_flex_groups[f].free_inodes);
>    328			if (is_directory)
>    329				atomic_dec(&sbi->s_flex_groups[f].used_dirs);
>    330		}
>    331		BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
>    332		fatal = ext4_handle_dirty_metadata(handle, NULL, bh2);
>    333	out:
>    334		if (cleared) {
>    335			BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
>    336			err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
>    337			if (!fatal)
>    338				fatal = err;
>    339		} else {
>    340			ext4_error(sb, "bit already cleared for inode %lu", ino);
>    341			if (!EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) {
>    342				int count;
>    343				count = ext4_free_inodes_count(sb, gdp);
>                                                                    ^^^
> Patch adds new unchecked dereference inside the function call.
> 
>    344				percpu_counter_sub(&sbi->s_freeinodes_counter,
>    345						   count);
> 
> regards,
> dan carpenter

