From: Tao Ma <tm@tao.ma>
Subject: Re: Ext4 projects for 2014
Date: Wed, 11 Dec 2013 13:42:47 +0800
Message-ID: <52A7FB57.7060201@tao.ma>
References: <20131209014330.GA9195@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	mingming.cao@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:44770 "EHLO server.coly.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab3LKFnZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Dec 2013 00:43:25 -0500
In-Reply-To: <20131209014330.GA9195@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted and Mingming,
On 12/09/2013 09:43 AM, Theodore Ts'o wrote:
> Unfortunately, I forgot my notes from our last conference call before
> heading off to the airport.  My fault for taking the notes on paper
> instead of electronically in the first place.  :-(
> 
> This is my best reconstruction of some of the ext4 projects for 2014.
> Please let me know if I've forgotten anything.
> 
> 1)  Support for Shingled (SMR) Drives
> 
> 2)  Data block compression -- Lukas
> 
> 3)  reflink support --- Mingming
>        block-level snapshot support
>        Use case:  (a) VM guest images which are mostly derived from
>        	   	      the same common master image
Any more details about your plan? And what advantage we can get over
QCOW2 and VHD?

Thanks,
Tao
> 
> 4)  Subvolume quotas (aka project quotas) -- Zheng
> 
> 5)  block improvements -- raid support / flash block size
> 
> 6)  Better support for non-rotating media
>        Differences between thinp and flash?
>        General problem: how do we measure improvements in the
>        block allocator?
> 
> Other more minor todo items:
> 
> A)  Finish integration of inline support in e2fsprogs
> 
> B)  Dioread nolock cleanup
> 
> C)  Extent status tree shrinker
> 
> 
> 						- Ted
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

