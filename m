From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Problem with 15TB logical volume
Date: Thu, 12 Aug 2010 14:24:59 -0400
Message-ID: <4C643C7B.8010303@redhat.com>
References: <20100812091635.GC2699@asrockhome.verdurin.salon> <4C63FA81.8060306@redhat.com> <20100812145130.GD2699@asrockhome.verdurin.salon> <7C289A14-A86A-47F6-B092-AFF94CF734AA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Adam Huffman <bloch@verdurin.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab0HLSZI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Aug 2010 14:25:08 -0400
In-Reply-To: <7C289A14-A86A-47F6-B092-AFF94CF734AA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2010-08-12, at 08:51, Adam Huffman wrote:
>>>> mke4fs -E stride=32 stripe-width=384 -i 65536 -j -v \
>>>> /dev/mapper/vg2md3000isata-homes2 
>>>>
>>>> mke4fs 1.41.9 (22-Aug-2009)
>>>> mke4fs: invalid blocks count - /dev/mapper/vg2md3000isata-homes2
> 
> I think if this was reported as:
> 
> mke4fs: invalid blocks count '/dev/mapper/vg2md3000isata-homes2'
> 
> it would definitely help.


maybe even better:

mke4fs: invalid blocks count '/dev/mapper/vg2md3000isata-homes2' on device 'stripe-width=384'

;)

-Eric
