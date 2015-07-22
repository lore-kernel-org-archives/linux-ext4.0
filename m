From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: check htree leaf block checksums
Date: Wed, 22 Jul 2015 00:07:05 -0400
Message-ID: <20150722040705.GF2944@thunk.org>
References: <20150622184112.GF7063@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51674 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbbGVEHH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jul 2015 00:07:07 -0400
Content-Disposition: inline
In-Reply-To: <20150622184112.GF7063@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 22, 2015 at 11:41:12AM -0700, Darrick J. Wong wrote:
> We weren't verifying the checksum of an htree leaf block due to a
> coding error that marked all htree blocks as not having checksums.
> While we're at it, fix the error message that gets displayed so that
> it doesn't print a meaningless block offset.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
