From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 13/29] ext4: Provide wrappers for transaction reservation
 calls
Date: Sun, 5 May 2013 19:51:34 +0800
Message-ID: <20130505115133.GA28373@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-14-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:65382 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3EELeB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 May 2013 07:34:01 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz17so1572515pbc.3
        for <linux-ext4@vger.kernel.org>; Sun, 05 May 2013 04:34:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-14-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:18PM +0200, Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/ext4/ext4_jbd2.c         |   71 +++++++++++++++++++++++++++++++++++++-----
>  fs/ext4/ext4_jbd2.h         |   13 ++++++++
>  include/trace/events/ext4.h |   20 +++++++++++-
>  3 files changed, 94 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 7058975..b3e04bf 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -38,28 +38,40 @@ static void ext4_put_nojournal(handle_t *handle)
>  /*
>   * Wrappers for jbd2_journal_start/end.
>   */
> -handle_t *__ext4_journal_start_sb(struct super_block *sb, unsigned int line,
> -				  int type, int nblocks)
> +static int ext4_journal_check_start(struct super_block *sb)
>  {
>  	journal_t *journal;
>  
> -	trace_ext4_journal_start(sb, nblocks, _RET_IP_);
>  	if (sb->s_flags & MS_RDONLY)
> -		return ERR_PTR(-EROFS);
> -
> +		return -EROFS;
>  	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
>  	journal = EXT4_SB(sb)->s_journal;
> -	if (!journal)
> -		return ext4_get_nojournal();
>  	/*
>  	 * Special case here: if the journal has aborted behind our
>  	 * backs (eg. EIO in the commit thread), then we still need to
>  	 * take the FS itself readonly cleanly.
>  	 */
> -	if (is_journal_aborted(journal)) {
> +	if (journal && is_journal_aborted(journal)) {
>  		ext4_abort(sb, "Detected aborted journal");
> -		return ERR_PTR(-EROFS);
> +		return -EROFS;
>  	}
> +	return 0;
> +}
> +
> +handle_t *__ext4_journal_start_sb(struct super_block *sb, unsigned int line,
> +				  int type, int nblocks)
> +{
> +	journal_t *journal;
> +	int err;
> +
> +	trace_ext4_journal_start(sb, nblocks, _RET_IP_);
> +	err = ext4_journal_check_start(sb);
> +	if (err < 0)
> +		return ERR_PTR(err);
> +
> +	journal = EXT4_SB(sb)->s_journal;
> +	if (!journal)
> +		return ext4_get_nojournal();
>  	return jbd2__journal_start(journal, nblocks, GFP_NOFS, type, line);
>  }
>  
> @@ -84,6 +96,47 @@ int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle)
>  	return err;
>  }
>  
> +handle_t *__ext4_journal_reserve(struct inode *inode, unsigned int line,
> +				 int type, int nblocks)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	journal_t *journal;
> +	int err;
> +
> +	trace_ext4_journal_reserve(sb, nblocks, _RET_IP_);
> +	err = ext4_journal_check_start(sb);
> +	if (err < 0)
> +		return ERR_PTR(err);
> +
> +	journal = EXT4_SB(sb)->s_journal;
> +	if (!journal)
> +		return (handle_t *)1;	/* Hack to return !NULL */
> +	return jbd2_journal_reserve(journal, nblocks, type, line);
> +}
> +
> +handle_t *ext4_journal_start_reserved(handle_t *handle)
> +{
> +	struct super_block *sb;
> +	int err;
> +
> +	if (!ext4_handle_valid(handle))
> +		return ext4_get_nojournal();
> +
> +	sb = handle->h_journal->j_private;
> +	trace_ext4_journal_start_reserved(sb, handle->h_buffer_credits,
> +					  _RET_IP_);
> +	err = ext4_journal_check_start(sb);
> +	if (err < 0) {
> +		jbd2_journal_free_reserved(handle);
> +		return ERR_PTR(err);
> +	}
> +
> +	err = jbd2_journal_start_reserved(handle);
> +	if (err < 0)
> +		return ERR_PTR(err);
> +	return handle;
> +}
> +
>  void ext4_journal_abort_handle(const char *caller, unsigned int line,
>  			       const char *err_fn, struct buffer_head *bh,
>  			       handle_t *handle, int err)
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 4c216b1..bb17931 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -309,6 +309,19 @@ static inline handle_t *__ext4_journal_start(struct inode *inode,
>  #define ext4_journal_stop(handle) \
>  	__ext4_journal_stop(__func__, __LINE__, (handle))
>  
> +#define ext4_journal_reserve(inode, type, nblocks)			\
> +	__ext4_journal_reserve((inode), __LINE__, (type), (nblocks))
> +
> +handle_t *__ext4_journal_reserve(struct inode *inode, unsigned int line,
> +				 int type, int nblocks);
> +handle_t *ext4_journal_start_reserved(handle_t *handle);
> +
> +static inline void ext4_journal_free_reserved(handle_t *handle)
> +{
> +	if (ext4_handle_valid(handle))
> +		jbd2_journal_free_reserved(handle);
> +}
> +
>  static inline handle_t *ext4_journal_current_handle(void)
>  {
>  	return journal_current_handle();
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 4ee4710..a601bb3 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -1645,7 +1645,7 @@ TRACE_EVENT(ext4_load_inode,
>  		  (unsigned long) __entry->ino)
>  );
>  
> -TRACE_EVENT(ext4_journal_start,
> +DECLARE_EVENT_CLASS(ext4_journal_start_class,
>  	TP_PROTO(struct super_block *sb, int nblocks, unsigned long IP),
>  
>  	TP_ARGS(sb, nblocks, IP),
> @@ -1667,6 +1667,24 @@ TRACE_EVENT(ext4_journal_start,
>  		  __entry->nblocks, (void *)__entry->ip)
>  );
>  
> +DEFINE_EVENT(ext4_journal_start_class, ext4_journal_start,
> +	TP_PROTO(struct super_block *sb, int nblocks, unsigned long IP),
> +
> +	TP_ARGS(sb, nblocks, IP)
> +);
> +
> +DEFINE_EVENT(ext4_journal_start_class, ext4_journal_reserve,
> +	TP_PROTO(struct super_block *sb, int nblocks, unsigned long IP),
> +
> +	TP_ARGS(sb, nblocks, IP)
> +);
> +
> +DEFINE_EVENT(ext4_journal_start_class, ext4_journal_start_reserved,
> +	TP_PROTO(struct super_block *sb, int nblocks, unsigned long IP),
> +
> +	TP_ARGS(sb, nblocks, IP)
> +);
> +
>  DECLARE_EVENT_CLASS(ext4__trim,
>  	TP_PROTO(struct super_block *sb,
>  		 ext4_group_t group,
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
