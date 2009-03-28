From: "J.D. Bakker" <jdb@lartmaker.nl>
Subject: Re: Once more: Recovering a damaged ext4 fs?
Date: Sat, 28 Mar 2009 13:53:35 +0100
Message-ID: <p06240592c5f3caee289b@[130.161.115.44]>
References: <p0624058dc5f2d7be08cc@[130.161.115.44]>
 <20090327224616.GD5176@mit.edu> <p0624058ec5f30b501efb@[130.161.115.44]>
 <20090328123035.GD2155@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.lartmaker.nl ([69.93.127.100]:43467 "EHLO www.lartmaker.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbZC1Mx2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Mar 2009 08:53:28 -0400
In-Reply-To: <20090328123035.GD2155@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At 08:30 -0400 28-03-2009, Theodore Tso wrote:
>Can you verify exactly what kernel version you are using? This issue
>is being discussed at:
>
>https://bugs.launchpad.net/ubuntu/+source/linux/+bug/330824
>
>... and one person has said it was fixed in 2.6.28-rc8, and at least
>one, possibly two people have reported that it has been fixed in
>2.6.29.  I think you're running some version of 2.6.28 or 2.6.28.y,
>correct?

Had the problem with 2.6.28, 2.6.28.4 and 2.6.29-rc6. After 
yesterday's crash I've upgraded to 2.6.29. For completeness' sake, my 
ext4 RAID had been created from scratch, not upgraded from ext3.

Should I still apply the oneliner you posted yesterday on 2.6.29?

In the meantime I've tried mkfs -S, this complained about "File 
exists while trying to create journal". fsck -y is running (has been 
for a few hours) and appears to cycle through

  Group xx inode table at yy conflicts with some other fs block. Relocate?
  [repeated enough times to overflow my xterm's scrollback buffer]
  Root inode is not a directory. Clear?

We'll see what I can fish out of the lost+found once it's done.

JDB.
-- 
LART. 250 MIPS under one Watt. Free hardware design files.
http://www.lartmaker.nl/
