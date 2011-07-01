From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: -E stride and stripe-width necessary for best performace of SSDs?
Date: Fri, 1 Jul 2011 12:03:26 -0400
Message-ID: <BANLkTinMoDXYn6x7aWzmvbVj3pqN7Rwn9g@mail.gmail.com>
References: <1309512654.5729.15.camel@werner-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Werner Fischer <devlists@wefi.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41648 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1GAQD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2011 12:03:57 -0400
Received: by bwd5 with SMTP id 5so2713392bwd.19
        for <linux-ext4@vger.kernel.org>; Fri, 01 Jul 2011 09:03:56 -0700 (PDT)
In-Reply-To: <1309512654.5729.15.camel@werner-t410>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

apologies for the re-send - first one bounced

On Fri, Jul 1, 2011 at 5:30 AM, Werner Fischer <devlists@wefi.net> wrot=
e:
>
> Hi,
>
> * I want to optimize ext4 on my SSD (Intel 320 Series 160 GB).
> * There are some sites recommending the use of the -E stride and -E
> =A0stripe-width paramaters, like
> =A0http://searchenterpriselinux.techtarget.com/tip/Optimizing-Linux-f=
or-SSD-usage
> * I know these parameters are useful for RAIDs, but I don't think tha=
t
> =A0they have any advantages for SSDs.
>
> Can anybody with deeper ext4 knowledge confirm if I'm right?
>
> Best regards,
> Werner

Werner,

That article is highly simplistic, and I dare say inaccurate due to
the simplifications.

=46or most of us SSDs are magic boxes we push data into and pull data o=
ut of.

We know the data gets stored on NAND chips and that many (most?) NAND
chips have 128KB Erase Blocks.

But we have no knowledge of how the data itself is organized.
Assuming that a Erase Block contains contiguous sectors is wrong in
most cases. There is sophisticated logic going on that is re-mapping
the data.  Those algorithms are NOT public. We definitely don't know
enough to know what stride etc. is optimal.

I personally think using 1MB for partition boundaries and a stride
which is a multiple of 4KB is probably best, but there really is no
good way to know other than performance testing the specific make /
model / firmware release you are working with.

Here's two wiki pages I wrote that may give you some background:

http://en.opensuse.org/SDB:SSD_Idle_Time_Garbage_Collection_support

http://en.opensuse.org/SDB:SSD_discard_%28trim%29_support

You might want to read them both, then read them both again because
the topics depend on each other.

And I just noticed this one:
http://en.opensuse.org/SDB:SSD_performance

I have no idea how accurate the last article is.  (I have not read/revi=
ewed it.)

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
