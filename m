From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
Date: Thu, 12 Mar 2009 16:04:31 -0400
Message-ID: <20090312200431.GG17104@mit.edu>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu> <1235451952-2726-2-git-send-email-tytso@mit.edu> <1235451952-2726-3-git-send-email-tytso@mit.edu> <1235451952-2726-4-git-send-email-tytso@mit.edu> <1235451952-2726-5-git-send-email-tytso@mit.edu> <49B83E01.1040605@redhat.com> <20090312052906.GA3033@skywalker> <49B93912.804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35205 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbZCLUEi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 16:04:38 -0400
Content-Disposition: inline
In-Reply-To: <49B93912.804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 12, 2009 at 11:32:18AM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > On Wed, Mar 11, 2009 at 05:41:05PM -0500, Eric Sandeen wrote:
> >> Theodore Ts'o wrote:
> >>> Add an ioctl which forces all of the delay allocated blocks to be
> >>> allocated.  This also provides a function ext4_alloc_da_blocks() which
> >>> will be used by the following commits to force files to be fully
> >>> allocated to preserve application-expected ext3 behaviour.
> >>>
> >> Is it worth checking whether a) the file has delalloc blocks, and/or b)
> >> whether the mapping is dirty before we spin off a filemap_flush?
> >>
> > +int ext4_alloc_da_blocks(struct inode *inode)
> > +{
> > +       if (!EXT4_I(inode)->i_reserved_data_blocks &&
> > +           !EXT4_I(inode)->i_reserved_meta_blocks)
> > +               return 0;
> > 
> > This check test does (a). Since the ioctl is to force allocation of
> > delayed allocated blocks i guess (a) is enough because we don't want to
> > cause a filemap_flush when we don't have any delayed allocated blocks
> > but have dirty pages around.
> 
> and b) is as simple as
> 
> if (!mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY))
> 	return 0;

Yeah, but (b) isn't necessary; if there are some delayed allocation
blocks, by definition there must be some dirty pages, right?

	   	      	    	    	 - Ted
