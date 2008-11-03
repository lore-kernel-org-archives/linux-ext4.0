From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 1/3] ext4: Add blocks added during resize to bitmap
Date: Sun, 2 Nov 2008 20:19:35 -0500
Message-ID: <20081103011935.GQ8134@mit.edu>
References: <1224830067-22963-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, frederic.bohe@bull.net, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43563 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752805AbYKCBTl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 20:19:41 -0500
Content-Disposition: inline
In-Reply-To: <1224830067-22963-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 24, 2008 at 12:04:25PM +0530, Aneesh Kumar K.V wrote:
> With this change new blocks added during resize
> are marked as free in the block bitmap and the
> group is flagged with EXT4_GROUP_INFO_NEED_INIT_BIT
> flag. This make sure when mballoc tries to allocate
> blocks from the new group we would reload the
> buddy information using the bitmap present in the disk.

Stupid question --- instead of reworking ext4_free_blocks_sb() and
renaming it be to called ext4_add_groupblocks(), and then forcing
mballoc() to reinitialize the block group, why not just have the
resize code call ext4_mb_free_blocks()?   

Also I had to make some minor changes to patches 2 and 3 to make them
apply against the latest tree (checked into the patch queue tree).  I
also changed calls to ext4_error() to use __func__ so the function
name in used in ext4_add_groupblocks() was correct in patch #1 --- but
I suspect that once you change resize to use ext4_mb_free_blocks(),
ext4_add_groupblocks()/ext4_free_blocks_sb() can go away entirely.

							- Ted
