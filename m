From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/3] e2fsprogs set_bmap & friends V2
Date: Tue, 20 May 2008 10:11:30 -0500
Message-ID: <4832EA22.2070301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124AbYETPLf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2008 11:11:35 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4KFBYXm019493
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:11:34 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KFBXOn008081
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:11:33 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KFBVuc017763
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 11:11:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

resend of the original 3 patches first, to address Ted's minor comments.

Then will follow up with the extent_delete fixups as a separate patch.

-Eric
