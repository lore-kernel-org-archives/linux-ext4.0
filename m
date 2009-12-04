From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Remove blocks from inode prealloc list on failure
Date: Thu, 3 Dec 2009 20:10:22 -0500
Message-ID: <20091204011022.GI10985@thunk.org>
References: <6601abe90912011017s41b74ed2nab4a45dc3f74825c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43064 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbZLDCnc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Dec 2009 21:43:32 -0500
Content-Disposition: inline
In-Reply-To: <6601abe90912011017s41b74ed2nab4a45dc3f74825c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 01, 2009 at 10:17:02AM -0800, Curt Wohlgemuth wrote:
> This fixes a leak of blocks in an inode prealloc list if device failures
> cause ext4_mb_mark_diskspace_used() to fail.

I was going to say that it didn't make sense for
ext4_discard_inode_pa() should be its own function, but maybe we need
function that returns blocks back to the either inode *or* the group
preallocation list?  Otherwise right now it looks like we would also
be potentially leaking blocks from the group preallocation list in
case of a device failure?

					- Ted
