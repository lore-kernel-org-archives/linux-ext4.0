From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/39] libext2fs: zero the EA block buffer before filling
 it
Date: Tue, 4 Nov 2014 11:47:52 -0500
Message-ID: <20141104164752.GE30614@thunk.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141025205649.532.60741.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38317 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbaKDQr6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 11:47:58 -0500
Content-Disposition: inline
In-Reply-To: <20141025205649.532.60741.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 25, 2014 at 01:56:49PM -0700, Darrick J. Wong wrote:
> When writing an extended attribute (EA) block, it's quite possible
> that the EA formatting code will not write the entire buffer.
> Therefore, we must zero the buffer beforehand to avoid writing random
> heap contents to disk.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Sami Liedes <sami.liedes@iki.fi>

Applied, thanks.

					- Ted
