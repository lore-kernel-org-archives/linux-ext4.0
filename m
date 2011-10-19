From: Johannes Segitz <johannes.segitz@gmail.com>
Subject: fsck.ext4 taking a very long time because of "should not have
 EOFBLOCKS_FL set"
Date: Wed, 19 Oct 2011 18:02:12 +0200
Message-ID: <CAFj9jjyLbPjehM1QbVAK9qRQ3F45sRpp055cKGa6EijWi1CBUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56569 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1JSQC3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2011 12:02:29 -0400
Received: by ggnb1 with SMTP id b1so1806270ggn.19
        for <linux-ext4@vger.kernel.org>; Wed, 19 Oct 2011 09:02:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

yesterday i was forced to start a fsck of an ext4 filesystem (4 TB on
a encrypted raid5 array). After a while a got a lot
of those messages:
Inode 23565579 should not have EOFBLOCKS_FL set (size 0, lblk -1)

After some googling i found this thread
http://kerneltrap.org/mailarchive/linux-ext4/2010/8/19/6885408/thread#mid-6885408

Since it's something that can be taken care of by using "-p" i started
it yesterday and was kind of surprised
to discover it running happily today with no sign of stopping. I piped
the output to /dev/null since the printing
of the messages alone caused quite a bit of load so i don't know at
which inode fsck currently is.

Is there a way to speed things up? If i understand the thread
correctly those errors should self correct over time
and i don't want to wait anymore. Can i do any harm by killing fsck
and start it again without the pipe to see
at which inode it currently is?

Bye,
Johannes
