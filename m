From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 30/74] libext2fs: fix a broken close() test
Date: Thu, 12 Dec 2013 13:18:14 -0500
Message-ID: <20131212181814.GA13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012141.30655.33189.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39446 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3LLSSQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 13:18:16 -0500
Content-Disposition: inline
In-Reply-To: <20131211012141.30655.33189.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:21:41PM -0800, Darrick J. Wong wrote:
> Zero is a valid file descriptor, so close it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
