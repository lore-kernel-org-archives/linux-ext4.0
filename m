From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH] ext4: add error handling when discard cmd is fail in FITRIM
Date: Wed, 1 Aug 2012 12:17:43 +0530
Message-ID: <CAOiN93mCtuJjPSa2tFfnwMJPsz7nuWjYM8MG+gSiGbBLbUabaw@mail.gmail.com>
References: <1343561514-8380-1-git-send-email-linkinjeon@gmail.com>
	<alpine.LFD.2.00.1207301323550.23560@localhost>
	<CAOiN93=SYN9jywq62M=Xh4LOLJ=E-UfHygYJ5uW_ANJ+Fw6qtQ@mail.gmail.com>
	<5017cf95.e288440a.2b45.ffffb603SMTPIN_ADDED@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48311 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2HAGro (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2012 02:47:44 -0400
In-Reply-To: <5017cf95.e288440a.2b45.ffffb603SMTPIN_ADDED@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> How about instead of propagating the error to user and breaking out of
>> the discard, just print a warning message like:
>> ext4_warning(sb, "error %d while trimming group block from %d to
>> %d\n",ret, start, next);
>
> That's what I said. I think that those errors should be logged, but
> I am not sure that doing it on fs level is such a good idea. Do you
> see any errors in the logs when the discard command fails ?
>
Ok, I understand your point. Discard errors should be logged at block
layer. Reasonable too.
This is already happening. In case of discard error:
#> ./fitrim_test
end_request: I/O error, dev mmcblk0, sector 27232
#>
#> echo $?
0
Even though error happend during discard, the return value is success.
I think this is little confusing.

Thanks,
Ashish
