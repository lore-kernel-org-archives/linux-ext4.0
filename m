From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6] e2fsck: Fix incorrect bbitmap checksum failure
 caused by integer overflow
Date: Mon, 16 Sep 2013 09:42:27 -0400
Message-ID: <20130916134227.GC4457@thunk.org>
References: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
 <20130829004404.3190.22438.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60993 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab3IPNm3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Sep 2013 09:42:29 -0400
Content-Disposition: inline
In-Reply-To: <20130829004404.3190.22438.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 28, 2013 at 05:44:04PM -0700, Darrick J. Wong wrote:
> On a filesystem with more than 2^32 blocks, the block group checksum test will
> fail because "i" (the group number) is a 32-bit quantity that is used to
> calculate the group's block bitmap block number.  Unfortunately, "i" is not
> automatically promoted to 64-bit for this calculation and overflows.  When this
> happens, e2fsck will incorrectly report bitmap checksum errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied to the next branch, thanks.

						- Ted
