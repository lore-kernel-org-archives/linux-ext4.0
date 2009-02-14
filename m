From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RESEND/PATCH] ext[234]: Return -EIO not -ESTALE on directory
	traversal missing inode
Date: Sat, 14 Feb 2009 09:14:11 -0500
Message-ID: <20090214141411.GD26628@mini-me.lan>
References: <1234588099-8445-1-git-send-email-bdonlan@fushizen.net> <1234588688-9497-1-git-send-email-bdonlan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
To: Bryan Donlan <bdonlan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34754 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbZBNPQx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Feb 2009 10:16:53 -0500
Content-Disposition: inline
In-Reply-To: <1234588688-9497-1-git-send-email-bdonlan@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 14, 2009 at 12:18:08AM -0500, Bryan Donlan wrote:
> The ext[234]_iget() functions in the ext[234] family of filesystems returns
> -ESTALE if invoked on a deleted inode, in order to report errors to NFS
> properly. However, in ext[234]_lookup(), this -ESTALE can be propagated to
> userspace if the filesystem is corrupted, and a inode is linked even
> though it is marked as deleted. 

I'm not sure what you mean by "inode is linked" here.  All you are
really proposing to do here is to remap the ESTALE error to EIO, yes?

> Apologies for the resend so quickly for those on the CC list - my mailer was
> misconfigured and the mail rejected by vger.

RESEND is a code word meaning --- "I sent this a few days/weeks ago
and no one responded; please look at it again?" I was confused when I
saw this, because I didn't remember seeing this, either in my inbox or
in the ext4 patchwork (which is really great and helping me make sure
I don't miss patches), so I spent a few extra minutes googling to see
what had gotten missed until I finally got to your apologies section....

I received two copies with the RESEND keyword; so I guess that means
you ended up sending it three times?  Anyway, apparently the first
time you sent it your mailer was so badly misconfigured that it got
dropped by mit.edu's mailer as well.  :-) In general if you end up
resending, don't worry about flagging it as a resend; deleting
duplicates is easy enough to do.

> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -66,8 +66,12 @@ static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, str
>  	inode = NULL;
>  	if (ino) {
>  		inode = ext2_iget(dir->i_sb, ino);
> -		if (IS_ERR(inode))
> -			return ERR_CAST(inode);
> +		if (unlikely(IS_ERR(inode))) {

I'm dubious about unlikely() here; OTOH, penalizing the error case
seems reasonable.

> +			if (PTR_ERR(inode) == -ESTALE)

Please add a call to ext2_error() here, and in make a similar change
for the ext3 and ext4 patches:

       	     	     		ext2_error(dir->i_sb, "ext2_lockup",
					   "deleted inode referenced: %u",
					   ino);

> +				return ERR_PTR(-EIO);
> +			else
> +				return ERR_CAST(inode);
> +		}
>  	}
>  	return d_splice_alias(inode, dentry);
>  }

						- Ted
