From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 03/22] ext4: Record the checksum algorithm in use in
	the superblock
Date: Mon, 5 Dec 2011 11:32:51 -0800
Message-ID: <20111205193251.GB7137@tux1.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com> <20111128232636.19194.92115.stgit@elm3c44.beaverton.ibm.com> <20111205154655.GB5488@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:58842 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab1LETdO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Dec 2011 14:33:14 -0500
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 5 Dec 2011 12:33:14 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pB5JWw5m138666
	for <linux-ext4@vger.kernel.org>; Mon, 5 Dec 2011 12:32:58 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pB5JWtEA018214
	for <linux-ext4@vger.kernel.org>; Mon, 5 Dec 2011 12:32:56 -0700
Content-Disposition: inline
In-Reply-To: <20111205154655.GB5488@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 05, 2011 at 10:46:55AM -0500, Ted Ts'o wrote:
> On Mon, Nov 28, 2011 at 03:26:36PM -0800, Darrick J. Wong wrote:
> > Record the type of checksum algorithm we're using for metadata in the
> > superblock, in case we ever want/need to change the algorithm.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> In general, it's useful to group changes to the on-disk file system
> separately from the other patches, so this should be grouped with the
> addition of s_csum_seed (aka c_uuid_csum) in patch #2, and all other
> patches that add metadata changes.  That way we can see easily what
> all of the metadata changes are, at the beginning of the patch, and
> make sure that what we have in the e2fsprogs patch set matches what we
> have in the ext4 patch set.

Ok, I'll reorganize the patches to put all the disk format changes into a
separate patch at the beginning of the set.

As for e2fsprogs, I think you already committed most of the disk format
changes.  I'll check the e2fsprogs set.

> Also, the change to actually *enable* a file system feature should be
> at the very end of the file system.  This makes life safer if at some
> point in the future we need to do a kernel bisect.  If we are
> advertising the present of some feature such in /sys/fs/ext4/features,
> that should also go at the very end of the patch set (again for
> obvious reasons), and it can be grouped with the patch which enables
> the feature being defined as being enabled in EXT4_FEATURE_*_SUPP.
> (This is really a comment about patch #2 in this series, but I forgot
> to mention it in my previous e-mail.)
> 
> A similar set of guidelines apply to patches for e2fsprogs as well.

Okay, I'll move the *_SUPP changes into a separate patch at the end of the
sets.

--D
> 
>   	      	 	    	     	     - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

