From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix dict_uint_cmp()
Date: Mon, 12 May 2014 08:16:43 -0400
Message-ID: <20140512121643.GA31376@thunk.org>
References: <536AEE3D.6090502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, yawei.niu@intel.com
To: Niu Yawei <yawei.niu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34462 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbaELMQr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 08:16:47 -0400
Content-Disposition: inline
In-Reply-To: <536AEE3D.6090502@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 08, 2014 at 10:38:53AM +0800, Niu Yawei wrote:
> dict_uint_cmp() returns an usigned int value in int type, which
> could mess the dict key comparison when the difference of two
> keys is greater than INT_MAX.
> 
> Signed-off-by: Niu Yawei <yawei.niu@intel.com>

Applied, thanks!

						- Ted
