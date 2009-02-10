From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 3/3] ocfs2: Add journal parameter to
	jbd2_journal_begin_ordered_truncate()
Date: Mon, 9 Feb 2009 19:19:17 -0800
Message-ID: <20090210031917.GD4341@mail.oracle.com>
References: <1233845582-954-1-git-send-email-jack@suse.cz> <1233845582-954-2-git-send-email-jack@suse.cz> <1233845582-954-3-git-send-email-jack@suse.cz> <1233845582-954-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, mfasheh@suse.de, mfasheh@suse.com,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:53237 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZBJDTn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 22:19:43 -0500
Content-Disposition: inline
In-Reply-To: <1233845582-954-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 05, 2009 at 03:53:02PM +0100, Jan Kara wrote:
> Add new parameter of the function.
> 
> CC: ocfs2-devel@oss.oracle.com
> CC: mfasheh@suse.de
> Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Joel Becker <joel.becker@oracle.com>

> ---
>  fs/ocfs2/journal.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 3c3532e..172850a 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -513,8 +513,10 @@ static inline int ocfs2_jbd2_file_inode(handle_t *handle, struct inode *inode)
>  static inline int ocfs2_begin_ordered_truncate(struct inode *inode,
>  					       loff_t new_size)
>  {
> -	return jbd2_journal_begin_ordered_truncate(&OCFS2_I(inode)->ip_jinode,
> -						   new_size);
> +	return jbd2_journal_begin_ordered_truncate(
> +				OCFS2_SB(inode->i_sb)->journal->j_journal,
> +				&OCFS2_I(inode)->ip_jinode,
> +				new_size);
>  }
>  
>  #endif /* OCFS2_JOURNAL_H */
> -- 
> 1.6.0.2
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
