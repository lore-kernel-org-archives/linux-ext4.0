From: Valerie Clement <Valerie.Clement@bull.net>
Subject: [RFC][PATCH 0/4] BIG_BG: support of large block groups
Date: 24 Nov 2006 17:47:40 +0100
Message-ID: <1164386860.17961.67.camel@ckrm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51886 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S934971AbWKXQ5W
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Nov 2006 11:57:22 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 8440119D932
	for <linux-ext4@vger.kernel.org>; Fri, 24 Nov 2006 17:57:17 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21068-09 for <linux-ext4@vger.kernel.org>;
 Fri, 24 Nov 2006 17:57:12 +0100 (CET)
Received: from ckrm.frec.bull.fr (unknown [172.16.109.44])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 9895819D931
	for <linux-ext4@vger.kernel.org>; Fri, 24 Nov 2006 17:57:12 +0100 (CET)
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Currently, the maximum number of blocks in a block group is the number
of bits in a block, since the block bitmap must be stored inside a
single block.
So on a 4 KB blocksize filesystem, the maximum number of blocks in a
group is 32768.
This constraint can limit the maximum size of the filesystem.

Increasing the block group size allows also to reduce the number of
groups in the filesystem.

This patchset allows using several consecutive blocks to store the
bitmaps, thus having larger block groups and so increasing the
filesystem size.

It applies against a linux-2.6.19-rc6 kernel and follows up the work on
the 64-bit support done by Laurent Vivier and Alexandre Ratchov.

These patches have been tested on a x86_64 machine with a 20TB device
and with updated e2fsprogs available here:
  http://www.bullopensource.org/ext4/20061124

If we already see that the execution time of fsck and mkfs commands is
reduced when increasing the size of groups on a large filesystem, I'll
will do performance testing in the next days to see the other impacts of
this modification.

Any comments are welcome.

Thanks,

  Valerie.
