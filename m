From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 20/49] libext2fs: fix parents when modifying extents
Date: Fri, 14 Mar 2014 10:01:58 -0400
Message-ID: <20140314140158.GP8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065605.30585.47791.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41385 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbaCNOCB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 10:02:01 -0400
Content-Disposition: inline
In-Reply-To: <20140311065605.30585.47791.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:56:05PM -0700, Darrick J. Wong wrote:
> In ext2fs_extent_set_bmap() and ext2fs_punch_extent(), fix the parents
> when altering either end of an extent so that the parent nodes reflect
> the added mapping.

Can you say more about what bug/symptom this fixes?

> There's a slight complication to using fix_parents: if there are two
> mappings to an lblk in the tree, the value of handle->path->curr can
> point to either extent afterwards), which is documented in a comment.

It's horribly wrong to map an lblk with two extents.  So the question
is at what places should we complain if we notice this.  In the ideal
world we would never allow an extent tree to be mutated in such a way
that it is invalid like this, but I am worried about the overhead
costs of always checking.  But if there are places where it wouldn't
take much effort to check, we should probably do so and return an
error.  (If the extent tree is already invalid, I suppose we should
allow error out the operation, since this would affect e2fsck and
debugfs.  I'm talking about checks to make sure that libext2fs or its
callers don't accidentally make things worse.)

	    	  	       	  - Ted

P.S.  I suppose the one possible valid use case for making an invalid
extent tree is a developer making an invalid extent tree for
regression testing, so maybe there should be an exemption for debugfs.

