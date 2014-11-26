From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use the shash api correctly for crc32c
Date: Tue, 25 Nov 2014 20:11:53 -0500
Message-ID: <20141126011153.GI28449@thunk.org>
References: <20141125213259.GM10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51975 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaKZBME (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 20:12:04 -0500
Content-Disposition: inline
In-Reply-To: <20141125213259.GM10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 25, 2014 at 01:32:59PM -0800, Darrick J. Wong wrote:
> Since we're using the crypto shash API, let's use the full API to set
> the seed and get the final checksum instead assuming the private data
> structure layout in crc32c.ko to which we're not privy.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
