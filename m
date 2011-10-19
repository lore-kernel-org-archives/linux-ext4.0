From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: fsck.ext4 taking a very long time because of "should not have EOFBLOCKS_FL set"
Date: Wed, 19 Oct 2011 10:22:16 -0600
Message-ID: <1DCB6B9B-6386-483E-B726-E2505690D224@gmail.com>
References: <CAFj9jjyLbPjehM1QbVAK9qRQ3F45sRpp055cKGa6EijWi1CBUw@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Johannes Segitz <johannes.segitz@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36219 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1JSQVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2011 12:21:24 -0400
Received: by gyb13 with SMTP id 13so1817580gyb.19
        for <linux-ext4@vger.kernel.org>; Wed, 19 Oct 2011 09:21:24 -0700 (PDT)
In-Reply-To: <CAFj9jjyLbPjehM1QbVAK9qRQ3F45sRpp055cKGa6EijWi1CBUw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-10-19, at 10:02 AM, Johannes Segitz <johannes.segitz@gmail.com> wrote:

> yesterday i was forced to start a fsck of an ext4 filesystem (4 TB on
> a encrypted raid5 array). After a while a got a lot
> of those messages:
> Inode 23565579 should not have EOFBLOCKS_FL set (size 0, lblk -1)
> 
> After some googling i found this thread
> http://kerneltrap.org/mailarchive/linux-ext4/2010/8/19/6885408/thread#mid-6885408
> 
> Since it's something that can be taken care of by using "-p" i started
> it yesterday and was kind of surprised
> to discover it running happily today with no sign of stopping. I piped
> the output to /dev/null since the printing
> of the messages alone caused quite a bit of load so i don't know at
> which inode fsck currently is.
> 
> Is there a way to speed things up? If i understand the thread
> correctly those errors should self correct over time
> and i don't want to wait anymore. Can i do any harm by killing fsck
> and start it again without the pipe to see
> at which inode it currently is?

You could always strace e2fsck to see what it is printing. 

Cheers, Andreas