From: "kaefert@gmail.com" <kaefert@gmail.com>
Subject: Re: e2fsck extremly slow after: EXT4-fs.. ext4_check_descriptors:
 Checksum for group .. failed
Date: Mon, 12 Nov 2012 17:29:31 +0100
Message-ID: <CACDumsT=cjmNFtAWKMXvkvujHgixEX44xEif+qo3Q04f1N=QsQ@mail.gmail.com>
References: <CACDumsQsF4JoqygHT+8wQKz-=zuMPjTccrK1mnHnAZsf36O_Cg@mail.gmail.com>
 <20121109000156.GQ19977@thunk.org> <CACDumsTj9S2eLNG+zNFY_9ZCZdKGDVVz5SF2BqapS3JvvYP8AA@mail.gmail.com>
 <20121112161646.GF4895@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36039 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2KLQ3x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Nov 2012 11:29:53 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so157686bkw.19
        for <linux-ext4@vger.kernel.org>; Mon, 12 Nov 2012 08:29:52 -0800 (PST)
In-Reply-To: <20121112161646.GF4895@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/11/12 Theodore Ts'o <tytso@mit.edu>:
>
> You said this is an external USB drive, right?  How big is it?

Yep, its an external USB3.0 3TB disk.

>  If it's affordable, something I would suggest doing is to make image copy
> (i.e., using dd or dd_rescue) to another external USB drive, just to
> rule out hardware issues.

I'm sorry but I don't have a spare one of those lying around, but
wouldn't I see hardware errors in the dmesg output?

>
> The Pass 1B/1C/1D errors, particularly if you are seeing the exact
> same pattern after running a full e2fsck -fy run, makes me suspicious
> that inode table blocks are getting written to the wrong location on
> disk --- and whether this is caused by the storage device failing in
> some strange way.
>
> Also, can you save the output of e2fsck to a file?  Direct the output
> to a log file, so I can look at it.  There are patterns of the
> "millions of entries of the same pattern" which you've elided which
> can be a hint.

Yep, no problem, I'll send you a complete output in an hour or two,
when I'm home.
I just omitted those since its really huge and it looked to me like if
its only counting from the smallest number to the biggest, and
skipping some numbers in between.

> Also, can you disable the German translation to make
> it easier for me to investigate?

Could you tell me how to disable the German translations? sorry...

>
> Thanks,
>
>                                                 - Ted


Thanks for looking into my issue!

Regards, Thomas
