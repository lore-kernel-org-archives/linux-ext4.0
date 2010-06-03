From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: Always journal quota file modifications
Date: Thu, 03 Jun 2010 13:07:41 +0400
Message-ID: <87eigo1o2q.fsf@openvz.org>
References: <1275488593-7237-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48819 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0FCJH6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jun 2010 05:07:58 -0400
Received: by bwz11 with SMTP id 11so589458bwz.19
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jun 2010 02:07:56 -0700 (PDT)
In-Reply-To: <1275488593-7237-1-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Wed, 2 Jun 2010 16:23:13 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> When journaled quota options are not specified, we do writes
> to quota files just in data=ordered mode. This actually causes
> warnings from JBD2 about dirty journaled buffer because ext4_getblk
> unconditionally treats a block allocated by it as metadata. Since
> quota actually is filesystem metadata, the easiest way to get rid
> of the warning is to always treat quota writes as metadata...
Absolutely agree with the fix, but I have a theoretical question.
Is is possible to solve the issue without handling quota's bh
via ext4_handle_dirty_metadata()?
As soon as i understand ext4_jbd2_file_inode() not works here
because bh is belongs to blkdev page-cache. In other words is it
possible provide ordering for blkdev's blocks in jbd2?
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c |   19 +++++--------------
>  1 files changed, 5 insertions(+), 14 deletions(-)
>
>   Ted, this patch fixes some JBD2 warning for me when running XFSQA
> with quotas enabled. I think this is a move into a direction you are
> trying to achieve as well. Will you merge the patch or should I do it?
>
> 								Honza
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4e8983a..a8cea08 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4030,7 +4030,6 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
>  	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
>  	int err = 0;
>  	int offset = off & (sb->s_blocksize - 1);
> -	int journal_quota = EXT4_SB(sb)->s_qf_names[type] != NULL;
>  	struct buffer_head *bh;
>  	handle_t *handle = journal_current_handle();
>  
> @@ -4055,24 +4054,16 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
>  	bh = ext4_bread(handle, inode, blk, 1, &err);
>  	if (!bh)
>  		goto out;
> -	if (journal_quota) {
> -		err = ext4_journal_get_write_access(handle, bh);
> -		if (err) {
> -			brelse(bh);
> -			goto out;
> -		}
> +	err = ext4_journal_get_write_access(handle, bh);
> +	if (err) {
> +		brelse(bh);
> +		goto out;
>  	}
>  	lock_buffer(bh);
>  	memcpy(bh->b_data+offset, data, len);
>  	flush_dcache_page(bh->b_page);
>  	unlock_buffer(bh);
> -	if (journal_quota)
> -		err = ext4_handle_dirty_metadata(handle, NULL, bh);
> -	else {
> -		/* Always do at least ordered writes for quotas */
> -		err = ext4_jbd2_file_inode(handle, inode);
> -		mark_buffer_dirty(bh);
> -	}
> +	err = ext4_handle_dirty_metadata(handle, NULL, bh);
>  	brelse(bh);
>  out:
>  	if (err) {
