From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] ext3: prevent reread after write IO error
Date: Thu, 14 Jan 2010 18:05:32 +0900
Message-ID: <4B4EDE5C.8040600@hitachi.com>
References: <4B4EB5B9.4020809@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Nick Piggin <npiggin@suse.de>,
	dle-develop@lists.sourceforge.net,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49068 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab0ANJFm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2010 04:05:42 -0500
In-Reply-To: <4B4EB5B9.4020809@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Hidehiro Kawai wrote:

> This patch fixes the similar bug fixed by commit 95450f5a.
> 
> If a directory is modified, its data block is journaled as metadata
> and finally written back to the right place.  Now, we assume a
> transient write erorr happens on that writeback.  Uptodate flag of
> the buffer is cleared by write error, so next access on the buffer
> causes a reread from disk.  This means it breaks the filesystems
> consistency.

After sending this patch, I noticed that I have to deal with
the bh_uptodate_or_lock() case as well.  Actually, I confirmed
a data block sharing happens between two inodes. Allocate a new
block, then modified bitmap goes to the fs, but it fails due to
a transient IO error.  Next access on the bitmap buffer cause a
reread from disk.  As a result, the allocated block becomes 
a FREE block!  So this block can be shared by different two inodes.

I'll send the revised version later.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

