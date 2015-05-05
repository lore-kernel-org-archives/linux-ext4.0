From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 21/35] tests: test undo file creation in
 e2fsck/resize2fs/tune2fs/mke2fs
Date: Tue, 5 May 2015 10:43:51 -0400
Message-ID: <20150505144351.GH9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023617.25243.96247.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45923 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993231AbbEEOnv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:43:51 -0400
Content-Disposition: inline
In-Reply-To: <20150402023617.25243.96247.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:36:17PM -0700, Darrick J. Wong wrote:
> Regression tests to ensure that we can create undo files and roll
> things back if need be.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
