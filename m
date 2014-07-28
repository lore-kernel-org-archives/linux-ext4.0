From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: check inline directory before converting
Date: Mon, 28 Jul 2014 13:54:21 -0400
Message-ID: <20140728175421.GB17378@thunk.org>
References: <20140725222356.GK8628@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32850 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaG1RyZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 13:54:25 -0400
Content-Disposition: inline
In-Reply-To: <20140725222356.GK8628@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 03:23:56PM -0700, Darrick J. Wong wrote:
> Before converting an inline directory to a regular directory, check
> the directory entries to make sure they're not obviously broken.
> This helps us to avoid a BUG_ON if one of the dirents is trashed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
