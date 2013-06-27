From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: "block_dump, bd" in debugfs
Date: Wed, 26 Jun 2013 23:39:49 -0400
Message-ID: <51CBB405.2080401@redhat.com>
References: <20130627030513.217820@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmx.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3F0Djx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 23:39:53 -0400
In-Reply-To: <20130627030513.217820@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/26/13 11:05 PM, jon ernst wrote:
> Hi, 
> When I use "block_dump" to dump certain block. I got 12288 bytes dumped.

output example?  It dumps a hexadecimal representation w/ octal
offsets, if you're counting bytes in the *text* output it'd be more than 4096.

> But I checked my block_size, it is 4k.
> At debugfs interactive prompt, it says "Dump contents of a block". So I am confused here. 
>  I read the code, it has    for (i=0; i<current_fs->blocksize; i+=16) ,I don't understand why I can get 12k output.

Each line represents 16 bytes worth of data, with the starting offset of each line in octal.

When I run it on nonrepeating data, line starting points go from 0000 to 7760 (octal) on a 4k block (so it ends at 07777, or offset 4095)

> Also at the beginning of each line. The output pattern is "0000, 0020, 0040, 0060, 0100, 0120", where are numbers such as"0080,"?

Identical lines are suppressed, similar to what hexdump does by default.  You might have had a "*" in between?

> Thanks in advance for any explanation.

I suppose manpage docs would help, but who has time to write those!  ;)

-Eric
