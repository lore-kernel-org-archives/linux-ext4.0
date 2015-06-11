From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: truncate issue in ext4 encryption.
Date: Thu, 11 Jun 2015 10:22:47 -0400
Message-ID: <20150611142247.GL24181@thunk.org>
References: <5578D184.40808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Seunghun Lee <waydi1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59892 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbbFKOWs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Jun 2015 10:22:48 -0400
Content-Disposition: inline
In-Reply-To: <5578D184.40808@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 11, 2015 at 09:08:36AM +0900, Seunghun Lee wrote:
> Hi,
> 
> I was running fsstress on encrypted ext4 image,
> and I hit BUG_ON(blocksize != PAGE_CACHE_SIZE); in __ext4_block_zero_page_range.
> 
> It occurs when I'm using filesytem that has small block size(1024 bytes).

Yes, we don't have support for blocksize != pagesize yet.  This should
have been prevented when the file system was mounted.  I thought we
had that check, but obviously we had forgotten to add it or it had
somehow gotten dropped.   Thanks for the bug report.

Regards,

						- Ted
