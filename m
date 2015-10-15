From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/8] ext4: promote ext4 over ext2 in the default probe
 order
Date: Thu, 15 Oct 2015 10:34:04 -0400
Message-ID: <20151015143404.GF17329@thunk.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215431.28872.84139.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52010 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbbJOOeG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 10:34:06 -0400
Content-Disposition: inline
In-Reply-To: <20151012215431.28872.84139.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:54:31PM -0700, Darrick J. Wong wrote:
> Prevent clean ext3 filesystems from mounting by default with the ext2
> driver (with no journal!) by putting ext4 ahead of ext2 in the default
> probe order.  This will have the effect of mounting ext2 filesystems
> with ext4.ko by default, which is a safer failure than hoping the user
> notices that their journalled ext3 is now running without a journal!
> 
> Users who require ext2.ko for ext2 can either disable ext4.ko or
> explicitly request ext2 via "mount -t ext2" or "rootfstype=ext2".
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
