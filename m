From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/27] e2fsck: resync jbd2 revoke code from Linux 3.16
Date: Tue, 26 Aug 2014 23:44:50 -0400
Message-ID: <20140827034450.GT11317@thunk.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234648.11171.8811.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51075 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbaH0Dow (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Aug 2014 23:44:52 -0400
Content-Disposition: inline
In-Reply-To: <20140816234648.11171.8811.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 04:46:48PM -0700, Darrick J. Wong wrote:
> Synchronize e2fsck's copy of revoke.c with the kernel's copy in
> fs/jbd2.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
