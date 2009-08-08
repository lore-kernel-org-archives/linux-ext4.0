From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 13930] New: non-contiguous files (64.9%) on a ext4 fs
Date: Fri, 7 Aug 2009 20:16:16 -0400
Message-ID: <20090808001616.GB13642@mit.edu>
References: <bug-13930-13602@http.bugzilla.kernel.org/> <20090807185853.GK3340@webber.adilger.int> <4A7C7BB8.2060904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, zelogik+bugzilla@gmail.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53732 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321AbZHHAQl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2009 20:16:41 -0400
Content-Disposition: inline
In-Reply-To: <4A7C7BB8.2060904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 07, 2009 at 02:08:40PM -0500, Eric Sandeen wrote:
> 
> Ah that crossed my mind, but since so many other e2fsprogs tools
> coalesce adjacent extents and report "1" I figured e2fsck was too
> (though I didn't look...)

No, actually e2fsck counts non-contiguous only when the extent is
non-adjacent to the previous extent.

What we may want to do though is to create some other statistic which
is something like "file has more than one contiguous run of blocks and
one or more contiguous runs of blocks is smaller than 512 blocks".
This will take into account that for very large files small amounts of
non-contiguousness is acceptable, although certainly not ideal.  But
if we report both number of non-contiguous files, and number of
fragmented files, it might be a good way of reflecting this.

We really do need to improve the ext4's block allocator, though.  What
we have here is definitely that needs improving.  Personally, I think
free space fragmentation problem caused by small files should be
higher priority, since although it isn't as blindly obvious by people
running e2fsprogs, in the long run the free space fragmentation will
cause files to get fragmented very badly when the filesystem ages and
as it gets full.

	   	     	      	     	    	       - Ted
