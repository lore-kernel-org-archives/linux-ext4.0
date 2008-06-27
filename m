From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd2: We shouldnot cap writeback when we are doing a
	journal commit
Date: Fri, 27 Jun 2008 16:52:28 -0700
Message-ID: <1214610748.6837.20.camel@mingming-laptop>
References: <1214590065-26891-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <48652D4D.9010202@redhat.com>  <20080627210439.GA15342@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:35976 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbYF0Xwj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2008 19:52:39 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5RNqSkU017093
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jun 2008 19:52:28 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5RNqSJk148248
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jun 2008 17:52:28 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5RNqR35001614
	for <linux-ext4@vger.kernel.org>; Fri, 27 Jun 2008 17:52:28 -0600
In-Reply-To: <20080627210439.GA15342@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I fold this change to the parent patch: delalloc-new-ordered-mode.patch
in patch queue

Mingming
On Fri, 2008-06-27 at 23:04 +0200, Jan Kara wrote:
> On Fri 27-06-08 13:11:25, Eric Sandeen wrote:
> > Aneesh Kumar K.V wrote:
> > > A journal commit need to make sure we submit data buffers before
> > > we submit the meta-data buffers in ordered mode. We should
> > > not be looking at BDI_CAP_NO_WRITEBACK when doing a journal commit.
> > > 
> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > and I don't think we'll ever even see that flag set...
> > 
> > Acked-by: Eric Sandeen <sandeen@redhat.com>
>   Yes, I also don't think it really matters :). So feel free to remove that
> check.
> 
> 								Honza
> > 
> > > ---
> > >  fs/jbd2/commit.c |    3 ---
> > >  1 files changed, 0 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > > index 32ca3c3..f8b3be8 100644
> > > --- a/fs/jbd2/commit.c
> > > +++ b/fs/jbd2/commit.c
> > > @@ -203,9 +203,6 @@ static int journal_submit_inode_data_buffers(struct address_space *mapping)
> > >  		.for_writepages = 1,
> > >  	};
> > >  
> > > -	if (!mapping_cap_writeback_dirty(mapping))
> > > -		return 0;
> > > -
> > >  	ret = generic_writepages(mapping, &wbc);
> > >  	return ret;
> > >  }
> > 

