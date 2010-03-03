From: tytso@mit.edu
Subject: Re: [PATCH 11/28] ext4: correctly calculate number of blocks for
 fiemap
Date: Wed, 3 Mar 2010 12:52:17 -0500
Message-ID: <20100303175217.GA3530@thunk.org>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
 <1267553925-6308-12-git-send-email-tytso@mit.edu>
 <4B8E1410.1010107@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Leonard Michlmayr <leonard.michlmayr@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36115 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab0CCRwZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Mar 2010 12:52:25 -0500
Content-Disposition: inline
In-Reply-To: <4B8E1410.1010107@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 03, 2010 at 04:47:28PM +0900, Akira Fujita wrote:
> 
> In 1KB block size, the overflow occurs at above line.
> Since last_blk is set 0xffffffff when len is equal to s_maxbytes.
> Therefore ext4_fiemap() can not get correct extent information
> with 0 length.  How about adding this change?

What do you think _is_ the correct thing to do when length is 0?  As
Leonard has already pointed out, fiemap_check_ranges() already filters
out the length=0 case.

					- Ted
