From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: Don't update superblock write time when filesystem
 is read-only
Date: Thu, 17 Sep 2009 09:46:59 -0500
Message-ID: <4AB24BE3.1090406@redhat.com>
References: <1253114473-16240-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbZIQOrA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Sep 2009 10:47:00 -0400
In-Reply-To: <1253114473-16240-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> This avoids updating the superblock write time when we are mounting
> the root file system read/only but we need to replay the journal; at
> that point, for people who are east of GMT and who make their clock
> tick in localtime for Windows bug-for-bug compatibility, and this will
> cause e2fsck to complain and force a full file system check.

Just out of curiosity, why does e2fsck even care?  Why is a fairly
common & explainable time delta the trigger for a full fsck?

It seems like this solution may have some implications for forensics, etc.

Thanks,
-Eric

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext3/super.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index a8d80a7..62c86af 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2321,7 +2321,18 @@ static int ext3_commit_super(struct super_block *sb,
>  
>  	if (!sbh)
>  		return error;
> -	es->s_wtime = cpu_to_le32(get_seconds());
> +	/*
> +	 * If the file system is mounted read-only, don't update the
> +	 * superblock write time.  This avoids updating the superblock
> +	 * write time when we are mounting the root file system
> +	 * read/only but we need to replay the journal; at that point,
> +	 * for people who are east of GMT and who make their clock
> +	 * tick in localtime for Windows bug-for-bug compatibility,
> +	 * the clock is set in the future, and this will cause e2fsck
> +	 * to complain and force a full file system check.
> +	 */
> +	if (!(sb->s_flags & MS_RDONLY))
> +		es->s_wtime = cpu_to_le32(get_seconds());
>  	es->s_free_blocks_count = cpu_to_le32(ext3_count_free_blocks(sb));
>  	es->s_free_inodes_count = cpu_to_le32(ext3_count_free_inodes(sb));
>  	BUFFER_TRACE(sbh, "marking dirty");

