From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Ext4: use unlikely to improve the efficiency of the
 kernel
Date: Sat, 12 Jan 2013 16:30:26 -0500
Message-ID: <20130112213026.GA19503@thunk.org>
References: <CAP9B-Qn1pnXaq2VaeMQvCct6AftGrxy+53zS9BDWLZAXNNaP2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: shilong wang <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42959 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab3ALVa3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Jan 2013 16:30:29 -0500
Content-Disposition: inline
In-Reply-To: <CAP9B-Qn1pnXaq2VaeMQvCct6AftGrxy+53zS9BDWLZAXNNaP2g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 12, 2013 at 01:57:13AM -0800, shilong wang wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Because the function 'sb_getblk' seldomly fails to return NULL
> value,it will be better to use 'unlikely' to optimize it.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Applied, thanks.

					- Ted
