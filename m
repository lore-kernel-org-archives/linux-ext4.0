From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: We shouldnot cap writeback when we are doing a
	journal commit
Date: Fri, 27 Jun 2008 23:04:39 +0200
Message-ID: <20080627210439.GA15342@duck.suse.cz>
References: <1214590065-26891-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <48652D4D.9010202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44023 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760649AbYF0VEk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jun 2008 17:04:40 -0400
Content-Disposition: inline
In-Reply-To: <48652D4D.9010202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 27-06-08 13:11:25, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > A journal commit need to make sure we submit data buffers before
> > we submit the meta-data buffers in ordered mode. We should
> > not be looking at BDI_CAP_NO_WRITEBACK when doing a journal commit.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> and I don't think we'll ever even see that flag set...
> 
> Acked-by: Eric Sandeen <sandeen@redhat.com>
  Yes, I also don't think it really matters :). So feel free to remove that
check.

								Honza
> 
> > ---
> >  fs/jbd2/commit.c |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > index 32ca3c3..f8b3be8 100644
> > --- a/fs/jbd2/commit.c
> > +++ b/fs/jbd2/commit.c
> > @@ -203,9 +203,6 @@ static int journal_submit_inode_data_buffers(struct address_space *mapping)
> >  		.for_writepages = 1,
> >  	};
> >  
> > -	if (!mapping_cap_writeback_dirty(mapping))
> > -		return 0;
> > -
> >  	ret = generic_writepages(mapping, &wbc);
> >  	return ret;
> >  }
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
