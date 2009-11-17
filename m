From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Remove failed journal checksum check
Date: Tue, 17 Nov 2009 17:05:42 +0100
Message-ID: <20091117160542.GB1923@atrey.karlin.mff.cuni.cz>
References: <20091114202755.GC4221@mit.edu> <1258316900-20808-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33376 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZKQQFh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 11:05:37 -0500
Content-Disposition: inline
In-Reply-To: <1258316900-20808-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Now that we are checking for failed journal checksums in the jbd2
> layer, we don't need to check in the ext4 mount path --- since a
> checksum fail will result in ext4_load_journal() returning an error,
> causing the file system to refuse to be mounted until e2fsck can deal
> with the problem.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/super.c |   20 --------------------
>  1 files changed, 0 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8662b2e..04c6690 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2721,26 +2721,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL)) {
>  		if (ext4_load_journal(sb, es, journal_devnum))
>  			goto failed_mount3;
  But shouldn't we set the EXT4_ERROR_FS flag? We don't semm to do this
in ext4_load_journal() when jbd2_journal_load() fails.

									Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
