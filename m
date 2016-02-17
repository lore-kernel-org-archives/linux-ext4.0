From: Pete <pete@leptonyx.com>
Subject: Bug: {m,a}time issue in ext4
Date: Wed, 17 Feb 2016 21:58:05 +0000
Message-ID: <0cde87b04ffccea1719810a6a93f353d@leptonyx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 7.mo7.mail-out.ovh.net ([46.105.43.131]:33194 "EHLO
	7.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423442AbcBQWdc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Feb 2016 17:33:32 -0500
Received: from mail329.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo7.mail-out.ovh.net (Postfix) with ESMTP id 0616CFF87EB
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2016 22:58:05 +0100 (CET)
Received: from RCM-2.101.50.50 (localhost [127.0.0.1])
	by mail329.ha.ovh.net (Postfix) with ESMTPA id C01E1300073
	for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2016 22:58:05 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I don't know if this is the right place to report this - please correct 
me if it isn't the case.

The touch command on Linux currently allows a user to set a file's 
{m,a}time field in an ext4 filesystem to datetimes outside the bounds 
allowed by the filesystem (1901-12-13 20:45:52 to 2446-05-10 23:38:55) 
with impunity, flagging no error or warning.

This results in the storing of the relevant modulo bits in i_{m,a}time 
and i_{m,a}time_extra, but retaining the erroneous original value at 
some place in the filesystem cache.

Thus, subsequent calls to stat or ls -l will display the erroneous 
value, and will carry on doing so until the filesystem is remounted, in 
which case the timestamp bits are then re-read from scratch and 
interpreted correctly by stat and ls -l.

This means, among other aspects, that someone can set an out-of-bounds 
value, unmount and remount the filesystem, and find the datetime to have 
changed from the one which they believed to have entered, and which was 
reported previously.

Behaviour observed in (kernel 4.4.0-3 / e2fsprogs-1.42.13-3.3.x86_64) 
and (kernel 3.19.0 / e2fsprogs 1.42.9).

