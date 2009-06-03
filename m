From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH,STABLE 2.6.29 06/18] ext4: Automatically allocate delay
	allocated blocks on close
Date: Wed, 3 Jun 2009 15:29:38 -0400
Message-ID: <20090603192938.GL31943@mit.edu>
References: <1243944479-20574-1-git-send-email-tytso@mit.edu> <1243944479-20574-2-git-send-email-tytso@mit.edu> <1243944479-20574-3-git-send-email-tytso@mit.edu> <1243944479-20574-4-git-send-email-tytso@mit.edu> <1243944479-20574-5-git-send-email-tytso@mit.edu> <1243944479-20574-6-git-send-email-tytso@mit.edu> <20090603181419.GN9002@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39675 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbZFCT3h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jun 2009 15:29:37 -0400
Content-Disposition: inline
In-Reply-To: <20090603181419.GN9002@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 03, 2009 at 12:14:19PM -0600, Andreas Dilger wrote:
> 
> Since some applications open files with open(..., O_WRONLY|O_CREAT|O_TRUNC)
> to avoid re-using existing files (and avoiding the need to check if the
> file already exists to modify the flags), it would make sense to set
> EXT4_STATE_DA_ALLOC_CLOSE only if the file previously had some data in it.
> 
> By the time we get to ext4_truncate() i_size is overwritten already, but
> it might make sense to also check i_disksize != 0 before setting this flag.
> Otherwise delayed allocation may be inadvertently disabled for these apps
> when it should not be.

Agreed; I'll make such a change for the ext4 patch queue.  We can
propagate such a patch to the -stable kernels once it's in mainline.

	       	       	      	      	      - Ted
