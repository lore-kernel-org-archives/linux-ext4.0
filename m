From: Ric Wheeler <rwheeler@redhat.com>
Subject: async commit & write barrier code
Date: Mon, 22 Sep 2008 13:20:31 -0400
Message-ID: <48D7D3DF.70505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43298 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbYIVRUf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Sep 2008 13:20:35 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m8MHKZbx017438
	for <linux-ext4@vger.kernel.org>; Mon, 22 Sep 2008 13:20:35 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8MHKYhU026778
	for <linux-ext4@vger.kernel.org>; Mon, 22 Sep 2008 13:20:34 -0400
Received: from localhost.localdomain (dhcp-100-19-94.bos.redhat.com [10.16.19.94])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m8MHKXeN007780
	for <linux-ext4@vger.kernel.org>; Mon, 22 Sep 2008 13:20:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


After today's call, I was poking around a bit to try and understand 
better how the async commit code plays with the write barrier.

journal_submit_commit_record seems to disable the barriers when async IO 
is enabled if I read the code correctly. If this is true, how can we 
provide any promises of on disk data integrity after an fsync()?

Regards,

Ric

