From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 24/35] copy-in: for files, only iterate file blocks that
 are mapped
Date: Tue, 5 May 2015 10:49:03 -0400
Message-ID: <20150505144903.GK9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023637.25243.95578.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45936 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993247AbbEEOtD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:49:03 -0400
Content-Disposition: inline
In-Reply-To: <20150402023637.25243.95578.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:36:37PM -0700, Darrick J. Wong wrote:
> Rewrite the file copy-in algorithm to detect smaller holes in the
> files we're copying in.  Use SEEK_DATA/SEEK_HOLE/FIEMAP when available
> to skip known empty parts.  This fixes the particular bug where zeroed
> blocks on a system with 64k pages are needlessly copied into a
> 4k-block filesystem.  It also saves time by skipping parts we know to
> be zeroed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
