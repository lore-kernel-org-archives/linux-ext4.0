From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/22] ext4: Record the checksum algorithm in use in
 the superblock
Date: Mon, 5 Dec 2011 10:46:55 -0500
Message-ID: <20111205154655.GB5488@thunk.org>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
 <20111128232636.19194.92115.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38138 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421Ab1LEPq4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 10:46:56 -0500
Content-Disposition: inline
In-Reply-To: <20111128232636.19194.92115.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 28, 2011 at 03:26:36PM -0800, Darrick J. Wong wrote:
> Record the type of checksum algorithm we're using for metadata in the
> superblock, in case we ever want/need to change the algorithm.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

In general, it's useful to group changes to the on-disk file system
separately from the other patches, so this should be grouped with the
addition of s_csum_seed (aka c_uuid_csum) in patch #2, and all other
patches that add metadata changes.  That way we can see easily what
all of the metadata changes are, at the beginning of the patch, and
make sure that what we have in the e2fsprogs patch set matches what we
have in the ext4 patch set.

Also, the change to actually *enable* a file system feature should be
at the very end of the file system.  This makes life safer if at some
point in the future we need to do a kernel bisect.  If we are
advertising the present of some feature such in /sys/fs/ext4/features,
that should also go at the very end of the patch set (again for
obvious reasons), and it can be grouped with the patch which enables
the feature being defined as being enabled in EXT4_FEATURE_*_SUPP.
(This is really a comment about patch #2 in this series, but I forgot
to mention it in my previous e-mail.)

A similar set of guidelines apply to patches for e2fsprogs as well.

  	      	 	    	     	     - Ted
