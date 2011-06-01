From: Vivek Goyal <vgoyal@redhat.com>
Subject: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Wed, 1 Jun 2011 17:50:49 -0400
Message-ID: <20110601215049.GC17449@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758812Ab1FAVuu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jun 2011 17:50:50 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p51LooIV002109
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jun 2011 17:50:50 -0400
Received: from machine.usersys.redhat.com (dhcp-100-18-250.bos.redhat.com [10.16.18.250])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p51Lone9019862
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jun 2011 17:50:50 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

If I throttle a DIO/AIO WRITE bio at block device in a cgroup, will it
lead to any kind of serialization of ext4 file system. IOW, is there any
filesystem operation which will wait for that DIO/AIO WRITE to finish
before other filesystem can make progress (fsync, journalling etc?)

I know that for throttling of buffered WRITES I do run into serialization
issues hence I was thinking of moving throttling buffered WRITE while
they are entering page cache and get rid of issues related to filesystem
serialization. I am not sure about DIO/AIO WRITES hence the question.

Thanks
Vivek
