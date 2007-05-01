From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext2/3 block remapping tool
Date: Tue, 1 May 2007 18:18:28 -0400
Message-ID: <20070501221828.GF26093@thunk.org>
References: <20070426192953.GC2841@duck.suse.cz> <20070427180942.GB5967@schatzie.adilger.int> <20070430120930.GA10604@thunk.org> <20070501060142.GZ5967@schatzie.adilger.int> <20070501152806.GC26093@thunk.org> <20070501185249.GG5722@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57967 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbXEAWSn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 May 2007 18:18:43 -0400
Content-Disposition: inline
In-Reply-To: <20070501185249.GG5722@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 01, 2007 at 12:52:49PM -0600, Andreas Dilger wrote:
> I think "rm -r" does a LOT of this kind of operation, like:
> 
> stat(.); stat(foo); chdir(foo); stat(.); unlink(*); chdir(..); stat(.)
> 
> I think "find" does the same to avoid security problems with malicious
> path manipulation.

Yep, so if you're doing an rm -rf (or any other recursive descent)
while we're doing an on-line shrink, it's going to fail.  I suppose we
could have an in-core inode mapping table that would continue to remap
inode numbers until the next reboot.  I'm not sure we would want to
keep the inode remapping indefinitely, although if we don't it could
also end up screwing up NFS as well.  Not sure I care, though.  :-)

					- Ted
