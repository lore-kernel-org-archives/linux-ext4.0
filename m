From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v3] ext4: move quota initialization out of inode
 allocation transaction
Date: Fri, 19 Apr 2013 21:21:49 +0200
Message-ID: <20130419192149.GA30218@quack.suse.cz>
References: <20130418214631.GA19244@quack.suse.cz>
 <1366327444-6123-1-git-send-email-tytso@mit.edu>
 <20130419143028.GA26647@quack.suse.cz>
 <20130419162453.GA20513@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab3DSTVy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 15:21:54 -0400
Content-Disposition: inline
In-Reply-To: <20130419162453.GA20513@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 19-04-13 12:24:53, Ted Tso wrote:
> On Fri, Apr 19, 2013 at 04:30:28PM +0200, Jan Kara wrote:
> > > +	inode->i_flags |= S_NOQUOTA;
> > > +	dquot_drop(inode);
> >   The above two lines have to be swapped to preserve original ordering
> > which is actually important. Thanks.
> > 
> > >  	iput(inode);
> 
> OK.  I'm confused --- what is the function of the S_NOQUOTA flag here?
> I thought it was dquot_drop() which needed this magic flag set.  I can
> swap these two lines, but maybe we should add a comment somewhere
> about why this flag is needed and what the heck it's doing?  At this
> point, the use of this flag seems like total magic to me.  :-(
  S_NOQUOTA flag means for quota code: Don't touch this inode, don't
account this inode or it's blocks. So in the file creation path we are
setting it when we bail out before inode is actually accounted in quota
(so that we don't decrease used inode count when freeing the inode
without incrementing it). To make things simple, we also set the flag when
the inode was already accounted for, but we handle the quota cleanup
ourselves (see fail_free_drop label).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
