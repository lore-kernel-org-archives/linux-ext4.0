From: Eric Sandeen <sandeen@redhat.com>
Subject: should ext2fs_get_device_size() be returning EFBIG for >8T (or 16T?)
Date: Tue, 23 Oct 2007 13:43:22 -0500
Message-ID: <471E40CA.2070500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXJWSnZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Oct 2007 14:43:25 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id l9NIhOSI031071
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 14:43:24 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9NIhOus001517
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 14:43:24 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9NIhN8T008174
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 14:43:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I have a bug saying hey, I can't grow my filesystem on a 16T device, and
it's because really we can only go to (2^32)-1 blocks, not (2^32)...

I was going to just silently round down by a block, because for example
LVM makes it *very* easy to make exactly 16T devices; dropping a block
at mkfs/growfs time seems reasonable to me.

So that led me to ext2fs_get_device_size, and I see it actually has the
maximum allowable filesystem size encoded in it, and you get EFBIG if
it's bigger.

I think this disallows you from being able to specify a smaller size on
the resize cmdline too; the device size check bails out before that.

I'm not sure what the plan is for size checks in the ext4 world, but it
seems to me that the device size check and the acceptable fs size checks
should be separate things.

Comments?

Thanks,
-Eric
