From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4 crypto: fix incorrect release for crypto ctx
Date: Sun, 31 May 2015 13:36:55 -0400
Message-ID: <20150531173655.GC11642@thunk.org>
References: <002901d099bb$656709d0$30351d70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Ext4 Developers List' <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com, jaegeuk@kernel.org
To: Chao Yu <chao2.yu@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39416 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758408AbbEaRhA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 May 2015 13:37:00 -0400
Content-Disposition: inline
In-Reply-To: <002901d099bb$656709d0$30351d70$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 29, 2015 at 10:58:09AM +0800, Chao Yu wrote:
> When ext4 encryption feature is enable, and our crypto resource
> was allocated, then if we rmmod ext4 module, we will receive a
> stack backtrace reported in syslog:
> 
> The reason is that:
> 
> since commit 66de766a0f11
> ("ext4 crypto: shrink size of the ext4_crypto_ctx structure") is merged,
> some fields in ext4_crypto_ctx structure are merged into a union as they
> will never be used simultaneously in write path, read path or on free list.

Thanks for pointing this out; as it turns out "ext4 crypto: shrink
size of the ext4_crypto_ctx structure" hasn't been merged yet (it's
still in the ext4 patch queue and the ext4 dev branch), so I'll just
fix up the commit and update the dev patch.

       	   	      	     	     - Ted
