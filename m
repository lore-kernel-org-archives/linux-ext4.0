From: Fredrick <fjohnber@zoho.com>
Subject: ext4_fallocate
Date: Sun, 24 Jun 2012 23:42:55 -0700
Message-ID: <4FE8086F.4070506@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([72.5.230.103]:45467 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab2FYHCy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jun 2012 03:02:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ext4 developers,

When calling fallocate on ext4 fs, ext4_fallocate does not initialize
the extents. The extents are allocated only when they are actually
written. This is causing a problem for us. Our programs create many
"write only once" files as large as 1G on ext4 very rapidly at times.
We thought fallocate would solve the problem. But it didnt.
If I change the EXT4_GET_BLOCKS_CREATE_UNINIT_EXT to
just EXT4_GET_BLOCKS_CREATE in the ext4_map_blocks in the ext4_fallocate 
call,
the extents get created in fallocate call itself. This is helping us.
Now the write throughtput to the disk was close to 98%. When extents 
were not
initialized, our disk throughput were only 70%.

Can this change be made to ext4_fallocate?

Thanks,
Fredrick

