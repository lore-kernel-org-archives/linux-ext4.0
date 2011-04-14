From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 14 Apr 2011 11:14:59 -0500
Message-ID: <4DA71D83.5040601@sandeen.net>
References: <20110414102608.GA1678@x4.trippels.de> <20110414120635.GB1678@x4.trippels.de> <20110414140222.GB1679@x4.trippels.de> <4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net> <4DA7182B.8050409@draigBrady.com> <4DA71920.9@sandeen.net> <20110414160343.GA12787@x4.trippels.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>,
	xfs-oss <xfs@oss.sgi.com>, linux-ext4@vger.kernel.org,
	coreutils@gnu.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37411 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759028Ab1DNQPA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 12:15:00 -0400
In-Reply-To: <20110414160343.GA12787@x4.trippels.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/14/11 11:03 AM, Markus Trippelsdorf wrote:
> On 2011.04.14 at 10:56 -0500, Eric Sandeen wrote:

...

>> well, if I simply take the preallocation step out of the testcase, it works fine on xfs without a sync.
>>
>> So I still don't know what Markus hit...
> 
> Maybe it's delalloc:
> 
> x4 /tmp # dd count=10 if=/dev/urandom conv=notrunc iflag=fullblock of=k                                                                               
> 10+0 records in
> 10+0 records out
> 5120 bytes (5.1 kB) copied, 0.0021822 s, 2.3 MB/s
> x4 /tmp # filefrag -v k 
> Filesystem type is: 58465342
> File size of k is 5120 (2 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0        0              16 unknown,delalloc,eof
> k: 1 extent found
> x4 /tmp # sync
> x4 /tmp # filefrag -v k 
> Filesystem type is: 58465342
> File size of k is 5120 (2 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0 26960045              16 eof
> k: 1 extent found
> 

well filefrag still returns that it knows of a valid range from logical blocks 0 to 16, so cp should have something to copy...

-Eric
