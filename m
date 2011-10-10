From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: "- 8" in EXT2_MAX_BLOCKS_PER_GROUP
Date: Mon, 10 Oct 2011 13:43:28 -0500
Message-ID: <4E933CD0.4050003@redhat.com>
References: <4E931453.3010002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1JJSn3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 14:43:29 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p9AIhTF7024060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Oct 2011 14:43:29 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p9AIhSb6032298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Oct 2011 14:43:29 -0400
In-Reply-To: <4E931453.3010002@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/10/11 10:50 AM, Eric Sandeen wrote:
> When looking at the maximal filesystem size issue, I found myself
> wondering what the "- 8" is in here, it's not commented
> or documented anywhere:
> 
> #define EXT2_MAX_BLOCKS_PER_GROUP(s)    (((1 << 16) - 8) *      \
>                                           (EXT2_CLUSTER_SIZE(s) / \
>                                            EXT2_BLOCK_SIZE(s)))
> 
> 
> (pre-bigalloc, it was just ((1 << 16) - 8) )
> 
> Anyone know?

Ah, Darrick pointed out

http://osdir.com/ml/file-systems.ext2.devel/2006-03/msg00032.html

So it would have been - 1, to not overflow __u16, but since we have
multiples of 8, we get - 8.

But now we have bg_free_blocks_count_hi, giving us 32 bits of counter.
With EXT4_FEATURE_INCOMPAT_64BIT, MAX_BLOCKS_PER_GROUP should grow, no?

-Eric
