From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/47] libext2fs: file IO routines should handle uninit
 blocks
Date: Tue, 2 Dec 2014 22:57:35 -0500
Message-ID: <20141203035735.GU13618@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215138.883.38987.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36118 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaLCD5m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 22:57:42 -0500
Content-Disposition: inline
In-Reply-To: <20141107215138.883.38987.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:51:38PM -0800, Darrick J. Wong wrote:
> The file IO routines do not handle uninit blocks at all.  The read
> method should check for the uninit flag and return a buffer of zeroes,
> and the write routine should convert unwritten extents.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
