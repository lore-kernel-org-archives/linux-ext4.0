From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 24/24] e2fuzz: Create a tool to fuzz ext* filesystems
Date: Fri, 25 Jul 2014 09:16:01 -0400
Message-ID: <20140725131601.GO1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225544.31374.24010.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56390 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbaGYNQE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 09:16:04 -0400
Content-Disposition: inline
In-Reply-To: <20140718225544.31374.24010.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:55:44PM -0700, Darrick J. Wong wrote:
> Creates a program that fuzzes only the metadata blocks (or optionally
> all in-use blocks) of an ext* filesystem.  There's also a script to
> automate fuzz testing of the kernel and e2fsck in a loop.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, with a minor change to add e2fuzz to the clean makefile rule.
Thanks for all of your hard work!

						- Ted
