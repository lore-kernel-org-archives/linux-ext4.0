From: Eric Sandeen <sandeen@redhat.com>
Subject: New e2fsprogs release?
Date: Tue, 13 Sep 2011 10:17:39 -0500
Message-ID: <4E6F7413.7030906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab1IMPRk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Sep 2011 11:17:40 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p8DFHeQN018312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 13 Sep 2011 11:17:40 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p8DFHdmc002525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 13 Sep 2011 11:17:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's approaching a year since the last e2fsprogs release, 1.41.14, with hundreds of commits since then.

a "WIP" release was made a few months ago in July, containing much of the 64-bit support.

I've put this WIP release into Fedora Rawhide, and I've had no complaints yet.

I'd like to get a little visibility into when 1.42 may be released, or what must be completed for this to be done.  I'd rather not ship F17 with a "WIP" release of a core package like this, if possible.

Ted, can you offer any guidance or insight?

Thanks,
-Eric

p.s. Would it be possible to retroactively tag v1.42-WIP-0702 in the tree?
