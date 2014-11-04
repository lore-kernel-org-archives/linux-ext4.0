From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/39] libext2fs: directory iteration mustn't walk off
 the buffer end
Date: Tue, 4 Nov 2014 11:37:15 -0500
Message-ID: <20141104163715.GD30614@thunk.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141025205642.532.35826.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38289 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaKDQhU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 11:37:20 -0500
Content-Disposition: inline
In-Reply-To: <20141025205642.532.35826.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 25, 2014 at 01:56:42PM -0700, Darrick J. Wong wrote:
> When we're iterating a directory, the loop control code reads the
> length of the next directory record, failing to account for the fact
> that there must be at least 8 bytes (the minimum size of a directory
> entry) left in the buffer to read the next directory record.  Fix the
> loop conditional so that we don't read off the end of the buffer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Sami Liedes <sami.liedes@iki.fi>

Applied, thanks.

					- Ted
