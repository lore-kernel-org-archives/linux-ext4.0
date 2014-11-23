From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: fix end of region partial cluster handling
Date: Sun, 23 Nov 2014 01:05:17 -0500
Message-ID: <20141123060517.GC4102@thunk.org>
References: <20141121145904.GE30246@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45768 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaKWGFX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2014 01:05:23 -0500
Content-Disposition: inline
In-Reply-To: <20141121145904.GE30246@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2014 at 09:59:04AM -0500, Eric Whitney wrote:
> ext4_ext_remove_space() can incorrectly free a partial_cluster if
> EAGAIN is encountered while truncating or punching.  Extent removal
> should be retried in this case.

I don't see anything in the patch below which retries the extent
removal; am I missing something?

Thanks,

						- Ted
