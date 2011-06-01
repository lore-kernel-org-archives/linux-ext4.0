From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Unify the upper limit of reserved blocks
 count
Date: Tue, 31 May 2011 20:11:14 -0400
Message-ID: <20110601001114.GC2629@thunk.org>
References: <4DAD2796.5010409@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36897 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161006Ab1FACW0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 May 2011 22:22:26 -0400
Content-Disposition: inline
In-Reply-To: <4DAD2796.5010409@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 19, 2011 at 03:11:34PM +0900, Kazuya Mio wrote:
> In e2fsprogs, the upper limit of reserved blocks count is a half of
> filesystem's blocks count. This patch fixes the incorrect checks of
> reserved blocks count.
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>

Applied, thanks.

						- Ted
