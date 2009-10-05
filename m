From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] pu branch: make fs->group_desc opaque
Date: Mon, 5 Oct 2009 10:57:23 -0400
Message-ID: <20091005145723.GG13512@mit.edu>
References: <4ABC2C83.8080504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44838 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbZJEO6C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Oct 2009 10:58:02 -0400
Content-Disposition: inline
In-Reply-To: <4ABC2C83.8080504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 24, 2009 at 09:35:47PM -0500, Eric Sandeen wrote:
> To prevent direct array indexing of fs->group_desc[i] (because
> the group_desc may be a different size for different filesystems)
> make it an opaque pointer that may only be accessed through the
> accessor functions in blknum.c.  The type itself is still available
> in a public header; if we have a group_desc that we know is one type
> or another, it's ok to access its fields directly.  This change only
> prevents us from indexing off fs->group_desc[i] directly.
>
> Change the accessors in blknum.c to use ext4fs_group_desc(), a version
> of ext2fs_group_desc() which returns a ext3_group_desc pointer.
>
> This simplifies and collapses a fair bit of code in blknum.c
>
> Tested with "make check" but no 64-bit testing yet.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, I've added it to the pu branch in my sources.

	     	      	     		      - Ted
