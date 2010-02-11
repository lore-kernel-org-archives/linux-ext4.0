From: tytso@mit.edu
Subject: The pu branch of e2fsprogs also updated
Date: Thu, 11 Feb 2010 02:30:18 -0500
Message-ID: <20100211073018.GH739@thunk.org>
References: <E1NfLwx-00062Q-AX@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53667 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab0BKHaU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Feb 2010 02:30:20 -0500
Content-Disposition: inline
In-Reply-To: <E1NfLwx-00062Q-AX@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've also updated the "pu", or "proposed updates" branch of e2fsprogs
to have my latest spin of the 64-bit patches.  They are nearly
completely cleaned up now, but they're not quite there yet.  Since I
need to context switch to getting kernel patches out the door, I
thought this would be a good time to update the pu branch.

The pu branch is now rebased against the latest 1.41.10 release, and
the remaining patches have been largely refactored.  The two patches
that still need a bit of cleanup and review are:

libext2fs: More random 64-bit fixes, lots of block_iterate3

and

Fix bug in selecting fs type, resulting in 1K blocksize

Otherwise, the patches have been refactored, the ABI breakage fixed,
and some API's cleaned up.  There are only a "bakers dozen" of patches
that still need to be merged into the mainline branch, so hopefully
the rest of cleanup will get done soon after I get the ext4 kernel
patch queue under control and ready for the merge window.

      	    	  	      	    	    - Ted
