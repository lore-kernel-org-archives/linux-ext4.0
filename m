From: "Nelson, John R" <John_Nelson@student.uml.edu>
Subject: Fsck and large file
Date: Sun, 28 Oct 2012 12:00:49 +0000
Message-ID: <0408C81F72528E40A0D3235A1F67FFC83ECD45F3@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:2244
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891Ab2J1MA4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Oct 2012 08:00:56 -0400
Received: from mail116-am1 (localhost [127.0.0.1])	by
 mail116-am1-R.bigfish.com (Postfix) with ESMTP id 12ECF4600CE	for
 <linux-ext4@vger.kernel.org>; Sun, 28 Oct 2012 12:00:54 +0000 (UTC)
Received: from AM1EHSMHS018.bigfish.com (unknown [10.3.201.230])	by
 mail116-am1.bigfish.com (Postfix) with ESMTP id 301C9180049	for
 <linux-ext4@vger.kernel.org>; Sun, 28 Oct 2012 12:00:52 +0000 (UTC)
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

How big of a file does FSCK consider a large file? I mean by the output snipplet below

  18713 inodes used (0.03%, out of 59727872)
         248 non-contiguous files (1.3%)
          29 non-contiguous directories (0.2%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 19083/39
    13643522 blocks used (5.71%, out of 238892544)
           0 bad blocks
           3 large files

       15803 regular files
        3318 directories
           0 character device files
           0 block device files
           0 fifos
           0 links
          14 symbolic links (14 fast symbolic links)
           0 sockets

