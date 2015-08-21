From: "Ki'Sak" <kisak42@gmail.com>
Subject: Fwd: Bulk block to filename lookups on an incomplete dd copy
Date: Thu, 20 Aug 2015 22:02:01 -0400
Message-ID: <CAL=yMgUZyGSMKL88Li=fpcOYijSe1eC0G9nmuyPMGiapqpmkjA@mail.gmail.com>
References: <CAL=yMgWXEqTj4ZAb2UdL8PCkeKjy=0mb95eVF+qukkOU=GF2Vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37844 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbbHUCCD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2015 22:02:03 -0400
Received: by widdq5 with SMTP id dq5so4283295wid.0
        for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2015 19:02:02 -0700 (PDT)
In-Reply-To: <CAL=yMgWXEqTj4ZAb2UdL8PCkeKjy=0mb95eVF+qukkOU=GF2Vw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Good day,

About a month ago I did an emergency dd copy of my 2TB home folder
drive, which I was able to salvage about 2/3's of the contents before
the source drive completely failed. In the post-mortum I have a
separate recovery drive with untouched data from the incident and a
replacement which is installed and in use. To mitigate spreading
filesystem damage from the incomplete copy, I have rsync'd the
contents from the recovery drive to the replacement drive.

In the last week I've been looking into what is needed to generate a
manifest of damaged files from a block range. For the most part, I
have intact superblocks on the recovery drive and have been looking
for a reliable method of finding what files were allocated to the
uncopied area. Unfortunately, I am faced with an unreasonable initial
need of scanning about 157 million 4k blocks. I'm looking at up to 40
minutes to icheck 1000 blocks if all the blocks are empty. I have
found that testb and the block bitmap are cheap, but is unreliable in
my scenario, where some random samplings I did revealed the block not
marked in use in the bitmap, but had inodes pointing to it.

>From what I can tell, I'm hitting a slow path (high cpu) when there is
an error with reading extents on empty blocks and was wondering if you
had any insight into reducing the processing cost of icheck with empty
block, which is averaging about 2.5 seconds or if I've missed
something fundimental in my approach.

I've thrown together a script at
https://github.com/Tele42/ext4scan/blob/master/ext4scan.sh for
posterity.

Thank you for your time,
Tele42

PS. Sorry for double sending this to Mr. Ts'o.
