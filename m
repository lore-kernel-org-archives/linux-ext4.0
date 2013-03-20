From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix ext4_evict_inode() racing against workqueue
 processing code
Date: Wed, 20 Mar 2013 09:37:51 -0400
Message-ID: <20130320133751.GC12865@thunk.org>
References: <1363742959-12815-1-git-send-email-tytso@mit.edu>
 <20130320132223.GD13294@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54597 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab3CTNhy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Mar 2013 09:37:54 -0400
Content-Disposition: inline
In-Reply-To: <20130320132223.GD13294@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 20, 2013 at 02:22:23PM +0100, Jan Kara wrote:
> > +	if (work_pending(&EXT4_I(inode)->i_unwritten_work))
> > +		flush_work(&EXT4_I(inode)->i_unwritten_work);
> >  }
>   Won't it be more logical to use cancel_work_sync() here?

Hmm.... yes, probably, but then ext4_ioend_wait() can only be safely
used by ext4_evict_inode().  I'll make the change, but I'll also make
a comment to this effect.  (No one else is using it now, but if there
was ever a need to use it while the inode was in use, using
cancel_work_sync() would be highly dagernous/racy.  That being said, I
can't really think of a good use case other than evict_inode path, so
it seems fine to make this change.)

					- Ted
