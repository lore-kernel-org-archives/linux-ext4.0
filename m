From: Pol Hallen <ext4@fuckaround.org>
Subject: Re: EXT4-fs (dm-0): unsupported inode size: 0
Date: Wed, 3 Nov 2010 13:38:04 +0100
Message-ID: <201011031338.04414.ext4@fuckaround.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vsmtp12.tin.it ([212.216.176.206]:46025 "EHLO vsmtp12.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab0KCMiH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Nov 2010 08:38:07 -0400
Received: from lorna.homeunix.org (87.15.143.204) by vsmtp12.tin.it (8.5.113)
        id 4BC85B971052554A for linux-ext4@vger.kernel.org; Wed, 3 Nov 2010 13:38:05 +0100
Received: from pollon.localnet (unknown [192.168.1.2])
	by lorna.homeunix.org (Postfix) with ESMTP id BB2F364C0B9
	for <linux-ext4@vger.kernel.org>; Wed,  3 Nov 2010 13:37:25 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Sounds like your superblock got corrupted in an interesting way.  Try
> "e2fsck -b 32768 /dev/disk".

exactly :-( but why?

This disk is perfect (almost.. I thinked :-)

smart monitor said is ok (smartmontools)

with you advice, after some time:

Error deallocating inode 21637778: Illegal doubly indirect block found
e2fsck: aborted

and now?

is a ext4 bug?

I used this disk 3 times..

Pol
