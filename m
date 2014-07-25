From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 23/24] mke2fs: set error behavior at initialization time
Date: Fri, 25 Jul 2014 09:00:19 -0400
Message-ID: <20140725130019.GN1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225536.31374.85052.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56365 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaGYNAU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 09:00:20 -0400
Content-Disposition: inline
In-Reply-To: <20140718225536.31374.85052.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:55:36PM -0700, Darrick J. Wong wrote:
> Port tune2fs' -e flag to mke2fs so that we can set error behavior at
> format time, and introduce the equivalent errors= setting into
> mke2fs.conf.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
