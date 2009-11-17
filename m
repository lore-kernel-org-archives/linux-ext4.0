From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] ext2: clear uptodate flag on super block I/O error
Date: Tue, 17 Nov 2009 09:16:03 -0800
Message-ID: <20091117091603.3d9abab9@nehalam>
References: <20091111123340.703f5c86@nehalam>
	<200911112234.24180.elendil@planet.nl>
	<20091113144727.575cf038@nehalam>
	<20091113150719.9d31dde2.akpm@linux-foundation.org>
	<20091116160449.3fc5e958@nehalam>
	<20091117020821.GF5818@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:36646 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbZKQRQS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Nov 2009 12:16:18 -0500
In-Reply-To: <20091117020821.GF5818@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> I think the real fix is to avoid clearing uptodate in case of io errors.
> For read io errors, the buffer/page should not have been uptodate to
> start with, and for write io errors, an error writing back the buffer
> does not mean it is somehow no longer the most uptodate copy of the data.
> 
> Higher level policy about IO errors (whether to retry, ignore, throw
> out the data, etc) would be nice to implement properly too, but that is
> not really the job of the low level cache and IO routines.
> 
> I proposed some patches a while back but didn't get much interest.
> Maybe I should just ask someone to merge them.

I am interested in fixing current releases. But I agree it should be handled
in a general way in future.
