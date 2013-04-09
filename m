From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Fwd: block level cow operation
Date: Tue, 9 Apr 2013 11:56:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1304091152430.22989@localhost>
References: <CAD6i1f+GsVZJwaz1R3NDjP_m8nOCUsmqHTQS3R=M+d+hq8f5vw@mail.gmail.com> <CAD6i1f+NLF6Vj8D84FFWAbDttqbBvcg-kWswf7Hez2o0-cXpMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Prashant Shah <pshah.mumbai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab3DIJ4z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 05:56:55 -0400
In-Reply-To: <CAD6i1f+NLF6Vj8D84FFWAbDttqbBvcg-kWswf7Hez2o0-cXpMw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 9 Apr 2013, Prashant Shah wrote:

> Date: Tue, 9 Apr 2013 14:35:56 +0530
> From: Prashant Shah <pshah.mumbai@gmail.com>
> To: linux-ext4@vger.kernel.org
> Subject: Fwd: block level cow operation
> 
> Hi,
> 
> I am trying to implement copy on write operation

Hi,

In ext4 ? Why are you trying to do that ?

> by reading the
> original disk block and writing it to some other location and then
> allowing the write to pass though (block the write operation till the
> read or original block completes) I tried using submit_bio() /
> sb_bread() to read the block and using the completion API to signal
> the end of reading the block but the performance of this is very bad.
> It takes around 12 times more time for any disk writes. Is there any
> better way to improve the performance ?

I am not sure what you're trying to achieve here, but the simplest
answer is yes, there is a way to improve the performance - use
device mapper to do this. thinp target provides you with block level
cow functionality which enables you to do snapshots efficiently for
example.

-Lukas

> 
> Not waiting for the completion of the read operation and letting the
> disk write go through gives good performance but under 10% of the
> cases the read happens after the write and ends up the the new data
> and not the original data.
> 
> Regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
