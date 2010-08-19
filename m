From: Ted Ts'o <tytso@mit.edu>
Subject: Re: buggy EOFBLOCKS_FL handling
Date: Thu, 19 Aug 2010 10:44:32 -0400
Message-ID: <20100819144432.GA23345@thunk.org>
References: <E1OlvNi-00063m-09@tytso-glaptop>
 <FB932B24-52F7-4C97-9BF6-58A78DFA5FBF@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36391 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0HSOof (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Aug 2010 10:44:35 -0400
Content-Disposition: inline
In-Reply-To: <FB932B24-52F7-4C97-9BF6-58A78DFA5FBF@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 18, 2010 at 11:13:00PM -0600, Andreas Dilger wrote:
> On 2010-08-18, at 21:01, Theodore Ts'o wrote:
> > It looks like how we handle the EOFBLOCKS_FL flag is buggy.  This means
> > that when we fallocate a file to have 128k using the KEEP_SIZE flag, and
> > then write exactly 128k, the EOFBLOCKS_FL isn't getting cleared
> > correctly.
> > 
> > This is bad, because e2fsck will then complain about that inode.  If you
> > have a large number of inodes that are written with fallocate using
> > KEEP_SIZE, and then fill them up to their expected size, e2fsck will
> > potentially complain about a _huge_ number of inodes.
> 
> Probably e2fsck also shouldn't complain if EOFBLOCKS_FL is set, but
> the i_size is within the range implied by i_blocks.

My current thinking is to have an EOFBLOCKS_relaxed mode setting in
/etc/e2fsck.conf which controls whether we test for this case or not.
Technically it *is* an error, but if there are file systems with a
large number of files in this state, running e2fsck could take a
***very*** long time (potentially, hours longer than would otherwise
be expected).  Hopefully once the bug fix gets pushed out, eventually
we'll be able to turn this feature off.  (Where eventually might be a
year or two, given that it's probably too late to get this fixed in
RHEL 6.  :-( )

	   	    	    	      - Ted

