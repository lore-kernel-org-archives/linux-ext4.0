From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fix ext4_free_inode vs. ext4_claim_inode race
Date: Wed, 4 Mar 2009 19:06:03 -0500
Message-ID: <20090305000603.GA30748@mit.edu>
References: <49AE05D1.9050607@redhat.com> <20090304190659.GB17949@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36486 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbZCEAGL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Mar 2009 19:06:11 -0500
Content-Disposition: inline
In-Reply-To: <20090304190659.GB17949@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 05, 2009 at 12:36:59AM +0530, Aneesh Kumar K.V wrote:
> On Tue, Mar 03, 2009 at 10:38:41PM -0600, Eric Sandeen wrote:
> > I was seeing fsck errors on inode bitmaps after a 4 thread
> > dbench run on a 4 cpu machine:
> > 
> > Inode bitmap differences: -50736 -(50752--50753) etc...
> > 
> > I believe that this is because ext4_free_inode() uses atomic
> > bitops, and although ext4_new_inode() *used* to also use atomic 
> > bitops for synchronization, commit 
> > 393418676a7602e1d7d3f6e560159c65c8cbd50e changed this to use
> > the sb_bgl_lock, so that we could also synchronize against
> > read_inode_bitmap and initialization of uninit inode tables.
> > 
> > However, that change left ext4_free_inode using atomic bitops,
> > which I think leaves no synchronization between setting & 
> > unsetting bits in the inode table.
> > 
> > The below patch fixes it for me, although I wonder if we're 
> > getting at all heavy-handed with this spinlock...
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Added to the ext4 patch queue.  I will push this to Linus after I do a
bit of testing.

      	     	  		       	    - Ted
