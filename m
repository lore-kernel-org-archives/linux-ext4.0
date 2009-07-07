From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] e2fsck: Remove unnecessary continue statement
Date: Mon, 6 Jul 2009 23:24:38 -0400
Message-ID: <20090707032438.GH31532@mit.edu>
References: <4A51B255.1090309@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57250 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZGGDYi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jul 2009 23:24:38 -0400
Content-Disposition: inline
In-Reply-To: <4A51B255.1090309@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 06, 2009 at 05:14:13PM +0900, Kazuya Mio wrote:
> Remove the continue statement because it calls at the end of the loop.

Thanks, applied.

						- Ted
