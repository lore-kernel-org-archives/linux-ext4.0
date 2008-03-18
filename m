From: Eric Sandeen <sandeen@redhat.com>
Subject: A few ext4dev images for which fsck segfaults on the next branch...
Date: Tue, 18 Mar 2008 13:50:22 -0500
Message-ID: <47E00EEE.3070305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937280AbYCSV14 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2008 17:27:56 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m2IIoNP6020794
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2008 14:50:23 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2IIoN8r013834
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2008 14:50:23 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id m2IIoM2t024868
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2008 14:50:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just in case anyone is bored... :)

http://sandeen.fedorapeople.org/ext4/fsck-segfault-images/

contains about 6 intentionally-corrupted ext4dev images which each cause
the e2fsck in the next branch to segfault for me on x86_64.

I'll find some time to look closer, but just thought I'd put them out
there for now.

-Eric
