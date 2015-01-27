From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/54] resize2fs: fix regression test to not depend on
 ext4.ko being loaded
Date: Tue, 27 Jan 2015 11:10:53 -0500
Message-ID: <20150127161053.GH2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073625.13308.27450.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35335 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbbA0QKy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 11:10:54 -0500
Content-Disposition: inline
In-Reply-To: <20150127073625.13308.27450.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:36:25PM -0800, Darrick J. Wong wrote:
> The behavior of the r_fixup_lastbg_big test varies depending on
> whether or not ext4.ko is loaded and supports lazy_itable_init.  This
> makes checking the bg flags after resize2fs hard to predict, so put in
> a way to force resize2fs to zero the inode tables, and compare the
> output based on lazy_itable_init == 0.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
