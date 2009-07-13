From: Theodore Tso <tytso@mit.edu>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Mon, 13 Jul 2009 09:05:07 -0400
Message-ID: <20090713130507.GA12833@mit.edu>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com> <20090617234604.GF7867@mit.edu> <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com> <20090701183130.GA31235@skywalker> <20090706034144.GB31532@mit.edu> <20090706153015.GB24136@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59338 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773AbZGMNFR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 09:05:17 -0400
Content-Disposition: inline
In-Reply-To: <20090706153015.GB24136@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 06, 2009 at 09:00:16PM +0530, Aneesh Kumar K.V wrote:
> > diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> > index be2f426..f800134 100644
> > --- a/fs/ext4/ext4_jbd2.h
> > +++ b/fs/ext4/ext4_jbd2.h
> > @@ -282,7 +282,7 @@ static inline int ext4_should_order_data(struct inode *inode)
> >  static inline int ext4_should_writeback_data(struct inode *inode)
> >  {
> >  	if (EXT4_JOURNAL(inode) == NULL)
> > -		return 0;
> > +		return 1;
> >  	if (!S_ISREG(inode->i_mode))
> >  		return 0;
> >  	if (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL)
> 
> We may want to change it after	if (!S_ISREG(inode->i_mode))
> So that we don't return 1 for other than regular files.

Thanks for the suggestion; I've made this change.

						- Ted
