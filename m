From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 24/51] ext3: wait on all pending commits in ext3_sync_fs
Date: Thu, 6 Nov 2008 17:42:02 -0500
Message-ID: <20081106224202.GA29038@mit.edu>
References: <200811062053.mA6KratV013440@imap1.linux-foundation.org> <20081106214431.GL18939@mit.edu> <20081106142020.b64dee83.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52633 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751065AbYKFWmF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 17:42:05 -0500
Content-Disposition: inline
In-Reply-To: <20081106142020.b64dee83.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 06, 2008 at 02:20:20PM -0800, Andrew Morton wrote:
> On Thu, 6 Nov 2008 16:44:31 -0500
> Theodore Tso <tytso@mit.edu> wrote:
> 
> > My version of this patch also cleaned up the following comment, which
> > has been wrong since 2.5.70 or thereabouts...
> 
> oh, I didn't spot that.
> 
> I looked at the version in linux-next and saw that it was propagating
> the error value back to the VFS as well.  Or maybe that was done in a
> separate patch, dunno.  But while that's a good change, I felt that we
> should separate it from this bugfix.  I meant to mention it but I
> forgot, sorry.

Fair enough.  Propagating the return value to the VFS is also a
cleanup, although given that the VFS drops return value on the floor,
I considered it a risk-free change and included it in the ext4 version
of the patch.  But yeah, I can see why separating could be argued to
be the right thing.

So that means we'll need two cleanup patches for ext3; one to fix the
comment, and another to propagate the error code back to the VFS.

	     	     		      	    	 - Ted
