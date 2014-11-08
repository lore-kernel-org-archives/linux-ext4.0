From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/47] dumpe2fs: don't crash when the user provides no
 block device argument
Date: Fri, 7 Nov 2014 21:26:37 -0500
Message-ID: <20141108022637.GC25485@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215102.883.8882.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46077 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbaKHC0j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Nov 2014 21:26:39 -0500
Content-Disposition: inline
In-Reply-To: <20141107215102.883.8882.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:51:02PM -0800, Darrick J. Wong wrote:
> If the user doesn't provide any arguments, the guard fails to run and
> the whole thing segfaults on ext2fs_open2().  Don't do that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
