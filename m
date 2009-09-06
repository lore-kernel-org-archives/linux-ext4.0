From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V2] libext2fs: use proper functions to set/clear block
	group flags
Date: Sun, 6 Sep 2009 12:29:48 -0400
Message-ID: <20090906162948.GI3055@mit.edu>
References: <4A9ED75A.7030406@redhat.com> <4A9EE55F.3030800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Ric Wheeler <rwheeler@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59735 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZIFQ3t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Sep 2009 12:29:49 -0400
Content-Disposition: inline
In-Reply-To: <4A9EE55F.3030800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 02, 2009 at 04:36:31PM -0500, Eric Sandeen wrote:
> As Justin & Ric reported, something like this on a
> 22T (sparse) bigfile:
> 
> 	e2fsprogs/misc/mke2fs -E lazy_itable_init=1 \
> 			      -O uninit_bg -b 4096 bigfile
> 	mount -o loop bigfile mnt/
> 	for I in `seq 1 5`; do mkdir mnt/$I; done
> 	umount mnt/
> 	e2fsprogs/e2fsck/e2fsck -f bigfile
> 
> would give us corrupted block group checksums:
> 
> 	<other problems related to uninit snipped>
> 	One or more block group descriptor checksums are invalid.  Fix<y>? yes
> 
> 	Group descriptor 6301 checksum is invalid.  FIXED.
> 	Group descriptor 7799 checksum is invalid.  FIXED.
> 
> There wer=re a few places which accessed bg_flags directly 
> rather than using the helper functions; fixing these seems
> to resolve the problem.
> 
> V2: use _flag_clear not _flags_clear, which clears all flags ...

Added to the e2fsprogs 64-bits patch set (and thus the pu branch).

      	     	       	       	     	      - Ted
