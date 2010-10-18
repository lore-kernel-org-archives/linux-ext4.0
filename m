From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext3: Avoid uninitialized memory references with a
 corrupted htree directory
Date: Mon, 18 Oct 2010 12:05:15 +0200
Message-ID: <20101018100515.GB3826@quack.suse.cz>
References: <20101016233513.GA31722@thunk.org>
 <1287272220-1591-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Brad Spengler <spender@grsecurity.net>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56408 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab0JRKGN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Oct 2010 06:06:13 -0400
Content-Disposition: inline
In-Reply-To: <1287272220-1591-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Ted,

  thanks for the patch.

On Sat 16-10-10 19:36:59, Theodore Ts'o wrote:
> @@ -871,6 +872,16 @@ static struct buffer_head *ext3_find_entry(struct inode *dir,
>  	namelen = entry->len;
>  	if (namelen > EXT3_NAME_LEN)
>  		return NULL;
> +	if ((namelen < 2) && (name[0] == '.') &&
> +	    (name[1] == '.' || name[1] == '0')) {
  This condition looks wrong... I suspect it should rather be:
  (namelen <= 2) && (name[0] == '.') && (name[1] == '.' || name[1] == 0)
           ^^^ change here                                  and here ^^^
> +		/*
> +		 * "." or ".." will only be in the first block
> +		 * NFS may look up ".."; "." should be handled by the VFS
> +		 */
> +		block = start = 0;
> +		nblocks = 1;
> +		goto restart;
> +	}

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
