From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: Automatically allocate delay allocated
	blocks on close
Date: Tue, 24 Feb 2009 08:21:03 -0500
Message-ID: <20090224132103.GC1362@mit.edu>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu> <1235451952-2726-2-git-send-email-tytso@mit.edu> <1235451952-2726-3-git-send-email-tytso@mit.edu> <1235451952-2726-4-git-send-email-tytso@mit.edu> <1235451952-2726-5-git-send-email-tytso@mit.edu> <1235451952-2726-6-git-send-email-tytso@mit.edu> <20090224101344.GN3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44799 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZBXNVL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 08:21:11 -0500
Content-Disposition: inline
In-Reply-To: <20090224101344.GN3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 03:13:44AM -0700, Andreas Dilger wrote:
> On Feb 24, 2009  00:05 -0500, Theodore Ts'o wrote:
> > When closing a file that had been previously truncated, force any
> > delay allocated blocks that to be allocated so that if the filesystem
> > is mounted with data=ordered, the data blocks will be pushed out to
> > disk along with the journal commit.  Many application programs expect
> > this, so we do this to avoid zero length files if the system crashes
> > unexpectedly.
> 
> Should this only be done with "truncate-to-zero" operations, or any
> truncate?  Some applications may do extending truncates in order to
> trigger file preallocation ala Windows, and we don't necessarily want
> to punish all of the IO for those files.

Agreed, we should only do this on a truncate-to-zero.  I'll fix up the
patch to only set EXT4_STATE_DA_ALLOC_CLOSE on truncate if
inode->i_size is 0.

							- Ted
