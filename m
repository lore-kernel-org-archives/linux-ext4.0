From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] added sanity check for xattr validation
Date: Fri, 22 Jun 2007 02:23:10 -0400
Message-ID: <20070622062310.GB17097@thunk.org>
References: <20070226223322.GA30215@schatzie.adilger.int> <467AE49D.6030207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org,
	Jim Garlick <garlick@llnl.gov>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47144 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbXFVGXV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 02:23:21 -0400
Content-Disposition: inline
In-Reply-To: <467AE49D.6030207@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 21, 2007 at 03:50:37PM -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > Ted,
> > the attached patch adds an extra validity test in check_ext_attr().  If
> > an attribute's e_value_size is zero the current code does not allocate
> > a region for it and as a result the e_value_offs value is not verified.
> > However, if e_value_offs is very large then the later call to
> > ext2fs_ext_attr_hash_entry() can dereference bad memory and crash e2fsck.
> 
> Did this patch get lost?  Don't see it in Hg...

Thanks, I just committed it.

						-Ted
