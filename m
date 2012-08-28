From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: Re: [PATCH] ext4: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
Date: Tue, 28 Aug 2012 21:38:24 +0800
Message-ID: <CAPgLHd92FsHK7S6NA8fg5hn_WCXtCH8DwO95YU8AFuB-pFK9=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: ashishsangwan2@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33260 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2H1NiY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Aug 2012 09:38:24 -0400
Received: by qcro28 with SMTP id o28so3354379qcr.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Aug 2012 06:38:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/28/2012 08:34 PM, Ashish Sangwan wrote:
> you can add 1 more.
> In function ext4_mb_new_blocks(), change:
> ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
> to
> ac = kmem_cache_zalloc(ext4_ac_cachep, GFP_NOFS); and remove
> memset(ac, 0, sizeof(struct ext4_allocation_context)); from
> ext4_mb_initialize_context().

got it, thanks, will include in the update version patch.

>
> On Mon, Aug 27, 2012 at 10:10 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Using kmem_cache_zalloc() instead of kmem_cache_alloc() and memset().
>>
>> spatch with a semantic match is used to found this problem.
>> (http://coccinelle.lip6.fr/)
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> ---
>>  fs/ext4/mballoc.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>


