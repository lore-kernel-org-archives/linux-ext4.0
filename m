From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/21] misc: fix various endianness problems with
 inline_data
Date: Sun, 10 Aug 2014 18:23:27 -0400
Message-ID: <20140810222327.GQ15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010530.2611.80567.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53453 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaHJWX3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:23:29 -0400
Content-Disposition: inline
In-Reply-To: <20140805010530.2611.80567.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:05:30PM -0700, Darrick J. Wong wrote:
> The inline data code fails to perform endianness conversions correctly
> or at all in a number of places, so fix this so that big-endian
> machines function properly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
