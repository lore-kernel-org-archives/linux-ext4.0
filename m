From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Problem with 15TB logical volume
Date: Thu, 12 Aug 2010 09:59:09 -0400
Message-ID: <4C63FE2D.8070500@redhat.com>
References: <20100812091635.GC2699@asrockhome.verdurin.salon> <4C63FA81.8060306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Adam Huffman <bloch@verdurin.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab0HLN7S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Aug 2010 09:59:18 -0400
In-Reply-To: <4C63FA81.8060306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

...

> Without the comma, mkfs thinks you are trying to mkfs a device called
> "stripe-width=384" with a block count of "<devicename>"
> 
> Odd eh ;)
> 
> Perhaps echoing back the blocks count which it found to be invalid
> (in this case the devicename string) would make the failure more
> obvious...
> 

Oh, actually, that is just what it's doing, but it's not obvious,
since it was the device name, and it looked like it was simply reporting
which device had the error...

-Eric

