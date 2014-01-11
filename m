From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 41/74] tests: adjust test output to reflect block_uninit
 calculated block bitmaps
Date: Sat, 11 Jan 2014 14:19:39 -0500
Message-ID: <20140111191939.GG1582@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012252.30655.19588.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47585 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaAKTTu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jan 2014 14:19:50 -0500
Content-Disposition: inline
In-Reply-To: <20131211012252.30655.19588.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:22:52PM -0800, Darrick J. Wong wrote:
> Now that libext2fs marks group metadata in the fs block bitmap, adjust
> the expected test output to reflect expanded use of block_uninit and
> the fact debugfs no longer prints block bitmap data that fails to
> account for group data blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
