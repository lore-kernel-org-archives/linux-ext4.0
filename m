From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 7/7] ext4: add might_sleep() annotations
Date: Tue, 26 Mar 2013 10:48:00 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303261047210.23176@localhost>
References: <1364170014-10295-1-git-send-email-tytso@mit.edu> <1364170014-10295-8-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab3CZJsF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 05:48:05 -0400
In-Reply-To: <1364170014-10295-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 24 Mar 2013, Theodore Ts'o wrote:

> Date: Sun, 24 Mar 2013 20:06:54 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 7/7] ext4: add might_sleep() annotations

Looks good and useful.

Thanks!
Signed-off-by: Lukas Czerner <lczerner@redhat.com>


> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4_jbd2.c | 6 ++++++
>  fs/ext4/mballoc.c   | 4 ++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 7058975..0e1dc9e 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -43,6 +43,8 @@ handle_t *__ext4_journal_start_sb(struct super_block *sb, unsigned int line,
>  {
>  	journal_t *journal;
>  
> +	might_sleep();
> +
>  	trace_ext4_journal_start(sb, nblocks, _RET_IP_);
>  	if (sb->s_flags & MS_RDONLY)
>  		return ERR_PTR(-EROFS);
> @@ -113,6 +115,8 @@ int __ext4_journal_get_write_access(const char *where, unsigned int line,
>  {
>  	int err = 0;
>  
> +	might_sleep();
> +
>  	if (ext4_handle_valid(handle)) {
>  		err = jbd2_journal_get_write_access(handle, bh);
>  		if (err)
> @@ -209,6 +213,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
>  {
>  	int err = 0;
>  
> +	might_sleep();
> +
>  	if (ext4_handle_valid(handle)) {
>  		err = jbd2_journal_dirty_metadata(handle, bh);
>  		if (err) {
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index ee6614b..36c82a3 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1011,6 +1011,7 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
>  	struct page *page;
>  	int ret = 0;
>  
> +	might_sleep();
>  	mb_debug(1, "init group %u\n", group);
>  	this_grp = ext4_get_group_info(sb, group);
>  	/*
> @@ -1082,6 +1083,7 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct inode *inode = sbi->s_buddy_cache;
>  
> +	might_sleep();
>  	mb_debug(1, "load group %u\n", group);
>  
>  	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
> @@ -4217,6 +4219,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>  	unsigned int inquota = 0;
>  	unsigned int reserv_clstrs = 0;
>  
> +	might_sleep();
>  	sb = ar->inode->i_sb;
>  	sbi = EXT4_SB(sb);
>  
> @@ -4470,6 +4473,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
>  	int err = 0;
>  	int ret;
>  
> +	might_sleep();
>  	if (bh) {
>  		if (block)
>  			BUG_ON(block != bh->b_blocknr);
> 
