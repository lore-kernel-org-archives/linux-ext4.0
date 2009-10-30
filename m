From: Duane Griffin <duaneg@dghda.com>
Subject: Re: xt4 - True Readonly mount [WAS - Re: [Bug 14354] Bad corruption
	with 2.6.32-rc1 and upwards]
Date: Fri, 30 Oct 2009 17:43:14 +0000
Message-ID: <e9e943910910301043n3e5e8816y74286b0c159a8a78@mail.gmail.com>
References: <87f94c370910300720s5ea3d780o45fcf32303820a3c@mail.gmail.com>
	 <4AEB02F0.5040309@redhat.com> <1256916681.3145.8.camel@mini>
	 <4AEB10DF.6090106@redhat.com> <1256921545.3145.51.camel@mini>
	 <4AEB1E9E.9020408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Ted Augustine <taugustine@techpathways.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62834 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601AbZJ3RnL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 13:43:11 -0400
Received: by bwz27 with SMTP id 27so3841779bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 10:43:14 -0700 (PDT)
In-Reply-To: <4AEB1E9E.9020408@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/10/30 Eric Sandeen <sandeen@redhat.com>:
> Alexey Fisher wrote:
>> Hmm... bdev. any chance to do temporary recovery and load it as external
>> journal if ro used? Anyway, you already pointed me to hdparm, so i can
>> use it too.
>
> There were patches floated to in-ram recovery for those blocks so that you
> could have a consistent fs w/o touching the disk but it didn't seem to get
> far.

Those were mine, I think. I got stuck at the point of needing to
handle escaped blocks -- I couldn't find any way of reliably and
efficiently getting hold of a buffer after it had been read from disk
but before anybody else had a chance to access it. I think if I could
have cracked that then I could have got it working. The only other
missing piece of functionality was handling the transition from
read-only (unrecovered) to read-write.

It would have needed a very thorough audit of the places where ext3
was doing ll_rw_block and such like, though.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
