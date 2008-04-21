From: Jan Kara <jack@suse.cz>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Mon, 21 Apr 2008 19:13:12 +0200
Message-ID: <20080421171312.GJ6119@duck.suse.cz>
References: <20080415161430.GC28699@duck.suse.cz> <1208282932.3636.9.camel@localhost.localdomain> <20080416093803.GB6116@duck.suse.cz> <20080418185447.GA3424@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36247 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755070AbYDURNO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 13:13:14 -0400
Content-Disposition: inline
In-Reply-To: <20080418185447.GA3424@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 18-04-08 12:54:47, Andreas Dilger wrote:
> On Apr 16, 2008  11:38 +0200, Jan Kara wrote:
> > On Tue 15-04-08 11:08:52, Mingming Cao wrote:
> > > I guess this reserve locking ordering allows support writepages() for
> > > ext3/4? What other the benefits?
> >
> >   Yes, that is one advantage. The other one (which I care about the most)
> > is that transaction commit code can take page_lock in the new locking order
> > which is necessary for the new ordered mode rewrite.
> 
> My understanding is that the main reason for the ordered mode rewrite is
> specifically to allow delalloc to still support ordered mode semantics.
> If the lock ordering is changed, and the jbd ordered mode is changed, but
> we don't support that with delalloc then we will have made a lot of changes
> (and likely introduced some bugs) with little benefit.
  Yes, with ordered mode rewrite, handling of data=ordered,delalloc is
going to be much simpler. But not that it would be my main motivation...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
