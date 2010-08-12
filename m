From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Problem with 15TB logical volume
Date: Thu, 12 Aug 2010 11:44:31 -0600
Message-ID: <7C289A14-A86A-47F6-B092-AFF94CF734AA@dilger.ca>
References: <20100812091635.GC2699@asrockhome.verdurin.salon> <4C63FA81.8060306@redhat.com> <20100812145130.GD2699@asrockhome.verdurin.salon>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Adam Huffman <bloch@verdurin.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:9131 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760456Ab0HLRod (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Aug 2010 13:44:33 -0400
In-Reply-To: <20100812145130.GD2699@asrockhome.verdurin.salon>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-12, at 08:51, Adam Huffman wrote:
>>> mke4fs -E stride=32 stripe-width=384 -i 65536 -j -v \
>>> /dev/mapper/vg2md3000isata-homes2 
>>> 
>>> mke4fs 1.41.9 (22-Aug-2009)
>>> mke4fs: invalid blocks count - /dev/mapper/vg2md3000isata-homes2

I think if this was reported as:

mke4fs: invalid blocks count '/dev/mapper/vg2md3000isata-homes2'

it would definitely help.

Cheers, Andreas





