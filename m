From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2image: ignore checksum errors
Date: Mon, 25 Apr 2016 12:03:08 -0400
Message-ID: <20160425160308.GB17864@thunk.org>
References: <20160419192030.GA16270@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37132 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbcDYQDN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2016 12:03:13 -0400
Content-Disposition: inline
In-Reply-To: <20160419192030.GA16270@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 19, 2016 at 12:20:30PM -0700, Darrick J. Wong wrote:
> Since e2image is used to capture broken fs images for debugging,
> ignore checksum errors when creating the image.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

BTW, the "m" series in tests was originally intended to be for mke2fs
tests.  However, some MMP tests have already been named m_*, and it
seems some folks have been assuming that miscellaneous tests should be
named m_*.

We do have already a category for e2image tests, which is "i", so I've
renamed the test to i_bad_csum.


						- Ted
