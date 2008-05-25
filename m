From: Christian Kujau <lists@nerdbynature.de>
Subject: remove bashism in lib/blkid/test_probe.in
Date: Sun, 25 May 2008 18:00:06 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0805251750250.4890@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53106 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYEYQAI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 May 2008 12:00:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

while running "make check" on a current e2fsprogs.pu git tree fails with:

----
cramfs: + test ! -f ./tests/cramfs.img.bz2 -a ! -f ./tests/cramfs.results
+ bunzip2
+ [ cramfs == swap0 ]
[: 1: ==: unexpected operator
+ [ cramfs == swap1 ]
[: 1: ==: unexpected operator
----

My /bin/sh is not linked to bash but to dash (which is basically "sh") and 
thus "==" comparisons fail. checkbashisms (part of Debian's devscripts)
catches this too:

----
possible bashism in ./test_probe line 26 (should be 'b = a'):
         if [ "$i" == "swap0" ]; then
----

Changing == to = makes "make check" happy :)
http://nerdbynature.de/bits/e2fsprogs.pu/test_probe.in.diff.txt

Thanks,
Christian.
-- 
BOFH excuse #169:

broadcast packets on wrong frequency
