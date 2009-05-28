From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] use unsigned values for memory tracking stats
Date: Thu, 28 May 2009 07:57:53 -0400
Message-ID: <20090528115753.GL26625@mit.edu>
References: <20090528064737.GF3218@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57108 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbZE1L6C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 07:58:02 -0400
Content-Disposition: inline
In-Reply-To: <20090528064737.GF3218@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 28, 2009 at 12:47:37AM -0600, Andreas Dilger wrote:
> Use unsigned values for printing memory tracking to avoid overflows.
> The mallinfo() data is currently signed ints, but it might change in
> the future so we may as well compute/print unsigned longs.
> 
> Signed-off-by: Andreas Dilger <adilger@sun.com>

Applied, thanks

						- Ted
