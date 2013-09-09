From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] libext2fs: ext2fs_dup_handle should not alias MMP
 buffers
Date: Mon, 9 Sep 2013 10:39:59 -0400
Message-ID: <20130909143959.GE6059@thunk.org>
References: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
 <20130829004350.3190.12494.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57023 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab3IIOkA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Sep 2013 10:40:00 -0400
Content-Disposition: inline
In-Reply-To: <20130829004350.3190.12494.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 28, 2013 at 05:43:51PM -0700, Darrick J. Wong wrote:
> It turns out that resize2fs uses ext2fs_dup_handle to duplicate fs handles.  If
> MMP is enabled, this causes both handles to share MMP buffers, which is bad
> news when it comes time to free both handles.  Change the code to (we hope) fix
> this.  This prevents resize2fs from failing with a double-free error when
> handed a MMP filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
