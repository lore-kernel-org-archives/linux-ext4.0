From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: Fix compile warnings
Date: Sat, 11 Jul 2009 14:52:10 -0400
Message-ID: <20090711185210.GB25844@mit.edu>
References: <4A56F18C.3060705@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35861 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZGKSwR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jul 2009 14:52:17 -0400
Content-Disposition: inline
In-Reply-To: <4A56F18C.3060705@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 10, 2009 at 04:45:16PM +0900, Kazuya Mio wrote:
> When compile e2fsprogs git tree with gcc-wall option, we get some
> warnings about e4defrag. This patch fixes them.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>

Applied, but I had to fix up this patch so it compiles normally.
(Without _GNU_SOURCE defined, struct FTW isn't defined, so a normal
"make" blows up.)

						- Ted
