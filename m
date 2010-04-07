From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/3] ext4: don't use quota reservation for speculative metadata
 blocks
Date: Wed, 07 Apr 2010 16:45:52 -0500
Message-ID: <4BBCFD10.3030504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab0DGVp4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 17:45:56 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o37LjtRo027995
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Apr 2010 17:45:55 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o37Ljqm1003737
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Apr 2010 17:45:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Because we can badly over-reserve metadata when we
calculate worst-case, it complicates things for quota, since
we must reserve and then claim later, retry on EDQUOT, etc.
Quota is also a generally smaller pool than fs free blocks,
so this over-reservation hurts more, and more often.

I'm of the opinion that it's not the worst thing to allow
metadata to push a user slightly over quota.  This simplifies
the code and avoids the false quota rejections that result
from worst-case speculation.

This patch series stops the speculative quota-charging for
worst-case metadata requirements, and just charges quota
when the blocks are allocated at writeout.  It also is
able to remove the try-again loop on EDQUOT.

The first 2 patches are quota infrastructure changes,
to change __dquot_alloc/free_space to take a flags argument,
and then add a NOFAIL option, so that metadata writes which
tip us over quota can proceed.

The last patch makes the ext4 changes.  The whole batch
has been tested indirectly by running the xfstests suite
with a hack to mount & enable quota prior to the test.

I also did a more specific test of fragmenting freespace
and then doing a large delalloc write under quota; quota
stopped me at the right amount of file IO, and then the
writeout generated enough metadata (due to the fragmentation)
that it put me slightly over quota, as expected.

Thanks,
-Eric
