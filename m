From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: optimize ext4_force_commit
Date: Mon, 1 Apr 2013 14:58:38 -0400
Message-ID: <20130401185838.GC22443@thunk.org>
References: <1364807037-21664-1-git-send-email-dmonakhov@openvz.org>
 <1364807037-21664-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57885 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278Ab3DAS6o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 14:58:44 -0400
Content-Disposition: inline
In-Reply-To: <1364807037-21664-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 01, 2013 at 01:03:57PM +0400, Dmitry Monakhov wrote:
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e3e6a06..280a918 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4436,13 +4436,14 @@ static void ext4_clear_journal_err(struct super_block *sb,
>   */
>  int ext4_force_commit(struct super_block *sb)
>  {
> -	journal_t *journal;
> +	tid_t target;
>  
>  	if (sb->s_flags & MS_RDONLY)
>  		return 0;
>  
> -	journal = EXT4_SB(sb)->s_journal;
> -	return ext4_journal_force_commit(journal);
> +	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target))
> +		return jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);

EXT4_SB(sb)->s_journal is NULL in no-journal mode.  So you need to
check for this --- this is something which is done in
ext4_journal_force_commit().

Since this is the only user of ext4_journal_force_commit(), you might
as well get rid of ext4_journal_force_commit() as part of making this
change.

The other possibility is we perhaps we should just change
jbd2_journal_force_commit() to call jbd2_journal_start_commit() and
jbd2_log_wait_commit(); the only other caller of
jbd2_journal_force_commit() is ocfs2_sync_file(), and it would benefit
from this change as well.

					- Ted
