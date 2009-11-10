From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/4]ext4: Fix block count in EXT4_IOC_MOVE_EXT failure
Date: Tue, 10 Nov 2009 16:52:53 -0500
Message-ID: <20091110215253.GC13262@mit.edu>
References: <4AEA98BE.9090007@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55435 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758263AbZKJVwv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2009 16:52:51 -0500
Content-Disposition: inline
In-Reply-To: <4AEA98BE.9090007@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 30, 2009 at 04:41:50PM +0900, Akira Fujita wrote:
> ext4: Fix block count in EXT4_IOC_MOVE_EXT failure
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> The halfway exchanged block count should be returned to the user-space,
> if EXT4_IOC_MOVE_EXT is failed for some reasons
> in the environment where block size is not same as page size.
> But current EXT4_IOC_MOVE_EXT returns
> page-aligned block count to the user-space.
> The patch fixes this issue.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Thanks, I've added this to the ext4 patch queue, but with the
following modified commit description:

ext4: Fix the returned block count if EXT4_IOC_MOVE_EXT fails

From: Akira Fujita <a-fujita@rs.jp.nec.com>

If the EXT4_IOC_MOVE_EXT ioctl fails, the number of blocks that were
exchanged before the failure should be returned to the userspace
caller.  Unfortunately, currently if the block size is not the same as
the page size, the returned block count that is returned is the
page-aligned block count instead of the actual block count.  This
commit addresses this bug.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

							- Ted
