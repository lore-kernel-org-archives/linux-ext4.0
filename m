From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 0/4] ext3/jbd: possible filesystem corruption fixes (take 3)
Date: Thu, 24 Jul 2008 21:34:27 +0900
Message-ID: <488876D3.80004@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	adilger@clusterfs.com, snitzer@gmail.com, tglx@linutronix.de,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: akpm@linux-foundation.org, sct@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48082 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYGXMep (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2008 08:34:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch set is the take 3 of fixing error handling problem in
ext3/JBD.  The previous discussion can be found here:
http://kerneltrap.org/mailarchive/linux-kernel/2008/6/2/2002094

Problem
=======
Currently some error checkings are missing, so the journal cannot abort
correctly.  This can cause a filesystem corruption.  Missing error
checkings are:

(1) error check for the metadata writes to the journal before the
    commit (addressed by PATCH 1/4)
(2) error check for checkpointing and replay (addressed by PATCH 2/4
    and 3/4)

PATCH 2/4 makes another problem worse; replaying old journaled
metadata can overwrite the latest metadata on the filesystem and
break its consistency.  This is fixed by PATCH 4/4.


Changes since Take 2
====================
[PATCH x/x]
o file data error handling fixes were separated to other patch set

[PATCH 3/4]
o fix return value handlings (trivial)

[PATCH 4/4]
o newly added to prevent unjournaled metadata buffers from being
  written to the filesystem on abort

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


