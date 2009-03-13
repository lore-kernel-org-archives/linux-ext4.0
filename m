From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fix bogus BUG_ONs in in mballoc code
Date: Thu, 12 Mar 2009 20:38:55 -0400
Message-ID: <20090313003855.GM17104@mit.edu>
References: <49B93E44.8070109@ph.tum.de> <49B958A1.6060805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42821 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZCMAjE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 20:39:04 -0400
Content-Disposition: inline
In-Reply-To: <49B958A1.6060805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 12, 2009 at 01:46:57PM -0500, Eric Sandeen wrote:
> Thiemo Nagel reported that:
> 
> # dd if=/dev/zero of=image.ext4 bs=1M count=2
> # mkfs.ext4 -v -F -b 1024 -m 0 -g 512 -G 4 -I 128 -N 1 \
>   -O large_file,dir_index,flex_bg,extent,sparse_super image.ext4
> # mount -o loop image.ext4 mnt/
> # dd if=/dev/zero of=mnt/file
> 
> oopsed, with a BUG_ON in ext4_mb_normalize_request because
> size == EXT4_BLOCKS_PER_GROUP
> 
> It appears to me (esp. after talking to Andreas) that the BUG_ON
> is bogus; a request of exactly EXT4_BLOCKS_PER_GROUP should
> be allowed, though larger sizes do indicate a problem.

Clearly we should make this change to avoid the BUG_ON; but stupid
question, why shouldn't we allow sizes larger than
EXT4_BLOCKS_PER_GROUP?  

Especially with flex_bg, it is possible for an allocation size >
EXT4_BLOCKS_PER_GROUP to be satisifed, especially if the filesystem
isn't that full yet, and it might even make sense to request a larger
allocation for video files that are getting preallocated, for
example....

						- Ted
