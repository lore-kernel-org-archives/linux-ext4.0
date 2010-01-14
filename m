From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Question about ext4 online defrag test case
Date: Thu, 14 Jan 2010 19:19:00 +0900
Message-ID: <4B4EEF94.5000902@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:54507 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab0ANKT0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2010 05:19:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

>E2defrag should hopefully be releasable in Karmic+1.
>There are still a lot of bugs that are still being fixed in the defrag code,
>some of which could cause data loss. They work fine
>if the system isn't under stress, sure, but acid test is to make sure
>things work OK even when the system is under memory pressure and
>swapping heavily, or when the file is being actively modified at the point
>where the defrag takes place.

I found your comment about ext4 online defrag on Ubuntu BBS by accident.
https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/321528

I would like to address this problem so I ran e4defrag on the system
which was under memory pressure. But unfortunately I could not find the bug.
If you have already known how to reproduce this kind of problem,
could you teach me how?

Regards,
Akira Fujita
