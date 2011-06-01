From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: Fix overflow of interval check
Date: Tue, 31 May 2011 20:11:24 -0400
Message-ID: <20110601001124.GD2629@thunk.org>
References: <4DAD279B.8070905@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36896 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161007Ab1FACW0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 May 2011 22:22:26 -0400
Content-Disposition: inline
In-Reply-To: <4DAD279B.8070905@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 19, 2011 at 03:11:39PM +0900, Kazuya Mio wrote:
> Add the check of maximum check interval.
> s_checkinterval is 32bit variable, so it cannot be set more than 2^32.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>

Applied, thanks.

					- Ted
