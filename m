From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/31] libext2fs: Fix off-by-one error in file truncation
Date: Tue, 8 Oct 2013 11:52:16 -0400
Message-ID: <20131008155216.GE17896@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012734.28415.45404.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43671 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab3JHPwj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Oct 2013 11:52:39 -0400
Content-Disposition: inline
In-Reply-To: <20131001012734.28415.45404.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:27:34PM -0700, Darrick J. Wong wrote:
> When told to truncate a file, ext2fs_file_set_size2 should start with the first
> block past the end of the file.  The current calculation jumps one more block
> ahead, with the result that it fails to hack off the last block.  Adding
> blocksize-1 and dividing is sufficient to find the last block.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
