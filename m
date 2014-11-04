From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/39] tune2fs: don't change metadata_csum on a mounted fs
Date: Tue, 4 Nov 2014 11:52:36 -0500
Message-ID: <20141104165236.GI30614@thunk.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141025205714.532.67707.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38339 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaKDQwj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 11:52:39 -0500
Content-Disposition: inline
In-Reply-To: <20141025205714.532.67707.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 25, 2014 at 01:57:15PM -0700, Darrick J. Wong wrote:
> Don't let users change metadata_csum on a mounted filesystem because
> there's no way to tell the kernel to turn on the feature; there's no
> way to prevent the kernel from rewriting on-disk structures while
> tune2fs is also rewriting them; and there's no way to tell the kernel
> to reload them after tune2fs is finished.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
