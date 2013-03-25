From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fold ext4_generic_write_end into ext4_write_end
Date: Sun, 24 Mar 2013 20:07:12 -0400
Message-ID: <20130325000712.GD26792@thunk.org>
References: <20130222152042.GA19264@thunk.org>
 <1364128156-13395-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55521 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab3CYAHO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Mar 2013 20:07:14 -0400
Content-Disposition: inline
In-Reply-To: <1364128156-13395-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 24, 2013 at 08:29:16PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After collpasing the handling of data ordered and data writeback
> codepath, ext4_generic_write_end has only one caller that is
> ext4_write_end.  So we fold it into ext4_write_end.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>

Applied, thanks.

						- Ted
