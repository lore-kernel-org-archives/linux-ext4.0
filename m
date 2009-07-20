From: Ron Johnson <ron.l.johnson@cox.net>
Subject: filefrag abort
Date: Mon, 20 Jul 2009 16:49:04 -0500
Message-ID: <4A64E650.6020603@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtao107.cox.net ([68.230.240.59]:43307 "EHLO
	eastrmmtao107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZGTWIW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jul 2009 18:08:22 -0400
Received: from eastrmimpo03.cox.net ([68.1.16.126])
          by eastrmmtao101.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20090720214906.LOVE22545.eastrmmtao101.cox.net@eastrmimpo03.cox.net>
          for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2009 17:49:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

(Is this OT?  http://sourceforge.net/forum/forum.php?forum_id=7052 
doesn't show much activity...)

Debian Sid, e2fsprogs 1.41.8-1
Home-rolled 64-bit 2.6.30 with 32-bit userland

Is this ioctl32() error caused by a "disconnect" between kernel and 
userland?

Thanks

$ df -T /
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sdb2     ext3    34606072   8585632  24262528  27% /

# filefrag -v /bin/cp
Filesystem type is: ef53
Filesystem cylinder groups is approximately 265
File size of /bin/cp is 92476 (23 blocks, blocksize 4096)
  ext logical physical expected length flags
Calling get_bmap for block 0
Aborted

[92747.137445] ioctl32(filefrag:17217): Unknown cmd fd(3) 
cmd(c020660b){t:'f';sz:32} arg(ffca4c38) on /bin/cp

-- 
Scooty Puff, Sr
The Doom-Bringer
