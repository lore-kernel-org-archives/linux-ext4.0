From: Eric Sandeen <sandeen@redhat.com>
Subject: can we simplify the quota matrix in ext4?
Date: Tue, 21 Jun 2011 13:45:50 -0500
Message-ID: <4E00E6DE.9060208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab1FUSpw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2011 14:45:52 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5LIjqWD010459
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 14:45:52 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p5LIjocd018194
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 14:45:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was looking at 

62d2b5f2dcd3707b070efb16bbfdf6947c38c194 ext4: Always journal quota file modifications

and was thinking - if we always journal, why do we still have all the mount options etc for journaled quota?

I guess without -o usrjquota=foo we don't journal right from mount time, and there are a few other paths that get skipped, but those seem like details...

It seems that ideally - and perhaps this is hindsight - ext4 should have defaulted to journaled, QFMT_VFS_V1 quotas only... is there any reason not to?

I'm still not very well versed in vfs quota, but does it seem possible to move in this direction?  It seems odd that we should still be supporting unjournaled, vfsold-format quotas in ext4 these days.  What's the point?

If it seems possible to move in this direction within the exiting quota framework I'd be interested in trying to get it done.

Thanks,
-Eric
