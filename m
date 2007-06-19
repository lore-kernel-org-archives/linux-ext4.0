From: Alex Tomas <alex@clusterfs.com>
Subject: Re: delayed allocatiou result in Oops
Date: Tue, 19 Jun 2007 13:36:56 +0400
Message-ID: <4677A3B8.3000007@clusterfs.com>
References: <20070614072352.GA6517@localhost.sw.ru> <4672202C.4080304@clusterfs.com> <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com> <20070616081426.GB14349@localhost.sw.ru> <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com> <46778186.9030306@clusterfs.com> <20070619091628.GB20172@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:64060 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbXFSJhK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2007 05:37:10 -0400
In-Reply-To: <20070619091628.GB20172@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dmitry Monakhov wrote:
> But whole approach based on using PagePrivate bit and page->private
> ptr for special purposes is realy dengerous, and imho wrong,
> because avery fs-related code assume that page->private points to
> page_buffers. Especially this approach not work for blksize < pgsize.
> The best way to store/pass any block related info is buffer_head flags.
> This approach works for blksize < pgsize case  too.

it's not dangerous as buffer_heads is optional facility
and any filesystem is free to use them or not. or even
use own mechanism like reiser4 does. this is why struct
page got private field instead of buffers (in 2.4).

buffer_heads have cost - 56 bytes/page (on 32bit arch)
+ cpu cycles to maintain them.

current delayed allocation isn't supposed to work with
bsize != PAGE_CACHE_SIZE. this will be resolved by the
upcoming patch, but bsize == PAGE_CACHE_SIZE is worthwhile
to optimize, I believe.

thanks, Alex
