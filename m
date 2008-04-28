From: Eric Sandeen <sandeen@redhat.com>
Subject: jbd2 patches in stable queue
Date: Mon, 28 Apr 2008 15:07:07 -0500
Message-ID: <48162E6B.8010607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763046AbYD1UHJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 16:07:09 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m3SK79M1000526
	for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2008 16:07:09 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3SK78Mb019010
	for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2008 16:07:08 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3SK77aS004312
	for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2008 16:07:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted et al:

these 3 patches in the stable queue:

patches/jbd2-tidy-up-revoke-cache-initialization-and-destruction.patch
patches/jbd2-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
patches/jbd2-replace-potentially-false-assertion-with-if-block.patch

don't seem to have their jbd counterparts merged anywhere, -mm or Linus'
tree.

Just a heads up, in case we don't want jbd2 to diverge further from jbd
by including them in the pull request.

Thanks,

-Eric

