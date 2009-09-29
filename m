From: Eric Sandeen <sandeen@redhat.com>
Subject: Where all does preallocated/extra space hide?
Date: Tue, 29 Sep 2009 11:47:19 -0500
Message-ID: <4AC23A17.5020100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbZI2QrR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Sep 2009 12:47:17 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8TGlLVH018729
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2009 12:47:21 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8TGlKR1020256
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2009 12:47:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was running some of the xfstests enospc tests on ext4, and they were
failing; in one case, manymanymany small files are made to fill up a
100M filesystem.  ext4 stops quite early with -ENOSPC, but after a bit,
(or after a "sync") we get 40MB free again.  So 40% of the fs space is
hidden somewhere in preallocation...

I tried calling out to discard group prealloc but that's only a few
blocks.  I'll go trace through the sync paths to see what all gets
released, but if anyone knows offhand where the rest of that space is
hiding, please give me a shout.  :)

Thanks,
-Eric
