From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/7] ext4: ext4_inode_info diet
Date: Thu, 13 Sep 2012 18:50:22 +0800
Message-ID: <20120913105022.GE11330@gmail.com>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58666 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab2IMKj6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 06:39:58 -0400
Received: by pbbrr13 with SMTP id rr13so3746672pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 03:39:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1347211634-11509-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 09, 2012 at 09:27:08PM +0400, Dmitry Monakhov wrote:
> Generic inode has unused i_private pointer which may be used as cur_aio_dio
> storage.
> 
> TODO: If cur_aio_dio will be passed as an argument to get_block_t this allow
>       to have concurent AIO_DIO requests.

Out of curiosity, could you please describe your idea about concurrent
AIO_DIO requests in get_block_t?  Thanks!

> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Looks good to me.  You can add:
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
Zheng
