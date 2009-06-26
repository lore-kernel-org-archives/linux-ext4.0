From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: Segmentation fault in e4defrag -c
Date: Fri, 26 Jun 2009 11:38:16 +0200
Message-ID: <20090626093816.GA3175@uio.no>
References: <20090625105558.GA21773@uio.no>
 <4A4487B0.9080000@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: a-fujita@rs.jp.nec.com, linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:46459 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbZFZJiR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Jun 2009 05:38:17 -0400
Content-Disposition: inline
In-Reply-To: <4A4487B0.9080000@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 26, 2009 at 05:32:48PM +0900, Kazuya Mio wrote:
> e4defrag -c works fine in the case without defrag patch.

I tried 2.6.31-rc1 now (which should have the defrag patch, right?).
There's no change -- and it still cannot actually defrag for some reason.

> To solve this problem, could you send me the following information?
> 1. mount option of /home/sesse

/dev/mapper/pannekake-home on /home type ext4 (rw,errors=remount-ro)

> 2. filefrag -v "/home/sesse/Mika - Life In Cartoon Motion/11 - Ring
> Ring (Bonus Track).mp3"

pannekake:~# filefrag -v "/home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3" 
Checking /home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3
Filesystem type is: ef53
Filesystem cylinder groups is approximately 315
File is stored in extents format
Blocksize of file /home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3 is 4096
File size of /home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3 is 4050385 (989 blocks)
First block: 0
Last block: 0
/home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3: 1 extent found

> 3. stat "/home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3"

pannekake:~# stat "/home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3" 
  File: `/home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3'
  Size: 4050385   	Blocks: 0          IO Block: 4096   regular file
Device: fd12h/64786d	Inode: 688755      Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/   sesse)   Gid: ( 1000/   sesse)
Access: 2009-05-30 03:08:38.724454316 +0200
Modify: 2008-09-01 20:38:26.135589449 +0200
Change: 2008-09-01 20:38:26.135589449 +0200

> Does this problem occur at all times?

Yes, it's 100% consistent on that file.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
