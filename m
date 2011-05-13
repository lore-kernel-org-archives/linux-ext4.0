From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Slow filesystem.
Date: Fri, 13 May 2011 14:59:58 +0200
Message-ID: <20110513125958.GA22871@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:57853 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1758529Ab1EMNAB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 May 2011 09:00:01 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi

My work (as in what brings in money to buy things from) file-system is
now "slow as hell". Last time this happened you guys told me that this
was because I had millions of hardlinks and way too many files.

Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/md0                815M    4.1M    811M    1% /recover2

I have only 4.1M files. Only 1% inodes "in use". 


The filesystem was filling up lately, but i've managed to create some
free space.

Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              6.3T  5.3T  720G  89% /recover2

 The question is: How do I get the filesystem to perform
normally again?


All mkdir calls are taking around 62 milliseconds: 

14:57:02 mkdir("...ME_25c8e/", 0777) = 0 <0.062312>
14:57:02 mkdir("...ME_112ff/", 0777) = 0 <0.062658>
14:57:02 mkdir("...ME_183cf/", 0777) = 0 <0.062344>

while on my workstation where i'm not supposed to be working
with client-data I get: 

14:58:18 mkdir("...ME_2a6c6/", 0777) = 0 <0.000033>
14:58:18 mkdir("...ME_2b3d9/", 0777) = 0 <0.000031>
14:58:18 mkdir("...ME_2c63f/", 0777) = 0 <0.000034>

So, things on my big datastorage drive are about 2000 times slower
than on my workstation.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
