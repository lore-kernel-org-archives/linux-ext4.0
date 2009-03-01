From: Eric Sandeen <sandeen@redhat.com>
Subject: how to scale root-reserved space going forward...
Date: Sun, 01 Mar 2009 16:22:54 -0600
Message-ID: <49AB0ABE.1030009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38004 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZCAWW6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Mar 2009 17:22:58 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n21MMumq012556
	for <linux-ext4@vger.kernel.org>; Sun, 1 Mar 2009 17:22:56 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n21MMv1M007961
	for <linux-ext4@vger.kernel.org>; Sun, 1 Mar 2009 17:22:57 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n21MMtHC023798
	for <linux-ext4@vger.kernel.org>; Sun, 1 Mar 2009 17:22:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

5% of a 16T filesystem is getting a little crazy from the point of view
of "root-reserved" - 800G!

But I think the original reason for this reserved space was actually as
an allocator cushion; letting root gain access to it was just a
safety-valve for that.

Now that we have a completely different allocator in ext4, and
potentially much larger filesystems, I think we need to revisit how much
is held back, and for what reason.

Any thoughts on a reasonable way to scale this reservation (or, just for
discussion - if it's even needed at all today for ext4?)

-Eric
