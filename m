From: Josef Bacik <jbacik@redhat.com>
Subject: [RFC] FIEMAP on ext3
Date: Wed, 16 Apr 2008 15:10:30 -0400
Message-ID: <20080416191030.GE15668@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848AbYDPTTc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2008 15:19:32 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m3GJJVZb027489
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 15:19:31 -0400
Received: from pobox.corp.redhat.com (pobox.corp.redhat.com [10.11.255.20])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3GJJVe5019213
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 15:19:31 -0400
Received: from unused (unused [10.11.231.15] (may be forged))
	by pobox.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3GJJV8B012501
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 15:19:31 -0400
Received: from unused (localhost.localdomain [127.0.0.1])
	by unused (8.14.1/8.14.1) with ESMTP id m3GJAUVh009852
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 15:10:30 -0400
Received: (from jwhiter@localhost)
	by unused (8.14.1/8.14.1/Submit) id m3GJAUQm009851
	for linux-ext4@vger.kernel.org; Wed, 16 Apr 2008 15:10:30 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Obviously ext3 doesn't have extents, however it would still be usefull to use it
on sparse files in order to find data/holes within a file.  What I'm thinking is
treat contigous allocated blocks as an extent, and contiguous non-allocated
blocks as extents.  So for example, with Eric's fiemap test program, on a normal
non-sparse file you would only see one large extent for the entire file.  In the
case of a file that has data, hole and then data you would see 3 extents, two
for the two spans of data and one for the span of holes.
FIEMAP_FLAG_NUM_EXTENTS would in that case return 3.  Does this sound like an
acceptable thing to do?  If not, are there any other suggestions on how to do
fiemap in ext3?  Thanks much,

Josef
