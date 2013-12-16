From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] mke2fs: fix force option to create filesystem on
 mounted device
Date: Mon, 16 Dec 2013 00:43:10 -0500
Message-ID: <20131216054310.GK28536@thunk.org>
References: <003b01ceeccc$869135b0$93b3a110$@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Andreas Dilger' <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40392 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab3LPFnP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Dec 2013 00:43:15 -0500
Content-Disposition: inline
In-Reply-To: <003b01ceeccc$869135b0$93b3a110$@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 29, 2013 at 03:30:41PM +0900, Kazuya Mio wrote:
> 
> According to mke2fs man, we can create a filesystem on the mounted device
> when -FF option is specified.
> However, currently we have to specify -F option third to force mke2fs.
> This patch fixes the problem.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Applied, thanks.

					- Ted
