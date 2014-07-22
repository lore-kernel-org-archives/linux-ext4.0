From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/24] e2fsck: report correct inode number in pass1b
Date: Tue, 22 Jul 2014 13:47:47 -0400
Message-ID: <20140722174747.GH25291@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225249.31374.59654.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50616 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbaGVUfG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 16:35:06 -0400
Content-Disposition: inline
In-Reply-To: <20140718225249.31374.59654.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:52:49PM -0700, Darrick J. Wong wrote:
> If there's a problem with the inode scan during pass 1b, report the
> inode that we were trying to examine when the error happened, not the
> inode that just went through the checker.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
