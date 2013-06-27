From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: "block_dump, bd" in debugfs
Date: Thu, 27 Jun 2013 00:00:13 -0400
Message-ID: <51CBB8CD.8090907@redhat.com>
References: <20130627035830.253590@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmx.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab3F0EA1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Jun 2013 00:00:27 -0400
In-Reply-To: <20130627035830.253590@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/26/13 11:58 PM, jon ernst wrote:
> ----- Original Message -----
> From: Eric Sandeen
> Sent: 06/26/13 11:39 PM
> To: jon ernst
> Subject: Re: "block_dump, bd" in debugfs
>  On 6/26/13 11:05 PM, jon ernst wrote:
>>> Hi, 
>>> When I use "block_dump" to dump certain block. I got 12288 bytes dumped.
> 
>> output example? It dumps a hexadecimal representation w/ octal
>> offsets, if you're counting bytes in the *text* output it'd be more than 4096.
> 
> 
> This is example:

<snip, I assume>

> 7020  ae1c aefc aef4 aedf ae65 ae83 ae2e ae19  .........e......

<my snip>

> 7760  ae42 ae44 ae04 ae0b aec9 ae62 aedd ae95  .B.D.......b....

Octal 07760 -> 0777, i.e. ending at byte 4095, or one full block.

-Eric

