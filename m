From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v3] ext4: move quota initialization out of inode
 allocation transaction
Date: Fri, 19 Apr 2013 12:24:53 -0400
Message-ID: <20130419162453.GA20513@thunk.org>
References: <20130418214631.GA19244@quack.suse.cz>
 <1366327444-6123-1-git-send-email-tytso@mit.edu>
 <20130419143028.GA26647@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42936 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221Ab3DSQZM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 12:25:12 -0400
Content-Disposition: inline
In-Reply-To: <20130419143028.GA26647@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 19, 2013 at 04:30:28PM +0200, Jan Kara wrote:
> > +	inode->i_flags |= S_NOQUOTA;
> > +	dquot_drop(inode);
>   The above two lines have to be swapped to preserve original ordering
> which is actually important. Thanks.
> 
> >  	iput(inode);

OK.  I'm confused --- what is the function of the S_NOQUOTA flag here?
I thought it was dquot_drop() which needed this magic flag set.  I can
swap these two lines, but maybe we should add a comment somewhere
about why this flag is needed and what the heck it's doing?  At this
point, the use of this flag seems like total magic to me.  :-(

					- Ted
