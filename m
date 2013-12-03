From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix printf conversion spec in tst_iscan.c
Date: Mon, 2 Dec 2013 23:37:50 -0500
Message-ID: <20131203043750.GA28445@thunk.org>
References: <20131111193213.GB6379@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35832 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab3LCEhy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 23:37:54 -0500
Content-Disposition: inline
In-Reply-To: <20131111193213.GB6379@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 11, 2013 at 02:32:13PM -0500, Eric Whitney wrote:
> A recent patch to fix blk_t to blk64_t assignment mismatches in
> e2fsprogs (commit 4dbfd79d1458ce1259b951377e341aeb6197f8c1) created
> a printf conversion spec / argument type mismatch in tst_iscan.c.
> Fix this to avoid truncation of the printed value and to silence
> a compiler warning seen when "make check" is run.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
