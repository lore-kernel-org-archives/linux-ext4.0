From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 1/3] ext2: improve ext2_readdir() return value
Date: Sun, 17 Feb 2008 07:09:26 -0500
Message-ID: <20080217120926.GE8905@mit.edu>
References: <20080217055612.GA3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63802 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549AbYBQMJr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Feb 2008 07:09:47 -0500
Content-Disposition: inline
In-Reply-To: <20080217055612.GA3390@APFDCB5C>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 17, 2008 at 02:56:13PM +0900, Akinobu Mita wrote:
> This patch improves ext2_readdir() return value for ext2_get_page() failure
> by using the actual result of ext2_get_page().

> -			return -EIO;
> +			return PTR_ERR(page);

The patch is harmless, and maybe even a good thing from an abstract
point of view, but you realize that EIO is the only thing that
ext2_get_page() can return, right?

						- Ted
