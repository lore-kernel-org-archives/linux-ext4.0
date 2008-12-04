From: Eric Sandeen <sandeen@redhat.com>
Subject: tune2fs -I seems dangerous
Date: Thu, 04 Dec 2008 16:26:47 -0600
Message-ID: <49385927.9070003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44453 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbYLDW0v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Dec 2008 17:26:51 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mB4MQnWx027051
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 17:26:49 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4MQmQ0032393
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 17:26:49 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mB4MQlpd007764
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 17:26:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As a small experiment...

dd if=/dev/zero of=fsfile bs=1M count=16
mkfs.ext4 -F -I 128 fsfile
mkdir -p mnt
mount -o loop fsfile mnt
for I in `seq 1 4096`; do echo $I > mnt/file.$I; done
umount mnt
tune2fs -I 256 fsfile
e2fsck -fy fsfile

... this yields 10031 lines of fsck output, and results in about 38% of
the files that were on the filesystem going missing.

I don't have the strong sense that tune2fs -I has been shaken out at
all; should it be shipping as a useable option?

Thanks,
-Eric




