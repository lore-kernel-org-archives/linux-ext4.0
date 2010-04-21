From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Wed, 21 Apr 2010 17:59:07 -0400
Message-ID: <4BCF752B.6050502@teksavvy.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>	 <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>	 <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>	 <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>	 <4BCF4C53.3010608@redhat.com>	 <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>	 <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>	 <4BCF67A9.2040902@redhat.com> <4BCF6831.7080506@redhat.com> <n2x87f94c371004211447w1e57ae43j4c988cf0205d7ec2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, sandeen@redhat.com,
	Eric Sandeen <esandeen@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Edward Shishkin <eshishki@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:17160 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753323Ab0DUV7T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 17:59:19 -0400
In-Reply-To: <n2x87f94c371004211447w1e57ae43j4c988cf0205d7ec2@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 21/04/10 05:47 PM, Greg Freemyer wrote:
>
> The ATA-8 spec. supports vectored trims and requires a minimum of 255
> sectors worth of range payload be supported.  That equates to a single
> trim being able to trim thousands of ranges in one command.
>
> Mark Lord has benchmarked in found a vectored trim to be drastically
> faster than calling trim individually for each of those ranges.
..

Does anyone have an Intel-based SSD they could spare?  :)

Rumour has it they they do not comply with the ATA-8 spec for TRIM,
in that they don't support more than one "sector" of range data.
The SSDs I have here all support much more than that.

Still, even if we just do a single 512-byte payload of TRIM ranges,
it would be a huge win.

Cheers
