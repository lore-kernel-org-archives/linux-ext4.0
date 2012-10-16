From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2] ext4: Remove code duplication in
 ext4_get_block_write_nolock()
Date: Tue, 16 Oct 2012 10:36:21 +0800
Message-ID: <20121016023621.GA5274@gmail.com>
References: <1350328009-22740-1-git-send-email-anatol.pomozov@gmail.com>
 <1350328009-22740-2-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, wenqing.lz@taobao.com, linux-ext4@vger.kernel.org
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39681 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab2JPCZU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2012 22:25:20 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so5507926pbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 19:25:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1350328009-22740-2-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2012 at 12:06:49PM -0700, Anatol Pomozov wrote:
> 729f52c6be51013 introduced function ext4_get_block_write_nolock() that
> is very similar to _ext4_get_block(). Eliminate code duplication
> by passing different flags to _ext4_get_block()
> 
> Tested: xfs tests
> 
> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>

Good catch. you can add:
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
