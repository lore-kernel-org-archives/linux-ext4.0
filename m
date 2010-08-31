From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] ext4: a couple writeback path fixes
Date: Tue, 31 Aug 2010 08:56:16 -0500
Message-ID: <4C7D0A00.40601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab0HaN4U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Aug 2010 09:56:20 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7VDuJG8001946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 31 Aug 2010 09:56:20 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o7VDuGkZ018721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 31 Aug 2010 09:56:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've found a couple small problems in the ext4_da_writepages path;

1) ext4_num_dirty_pages() can continue looping after max_pages is reached
   - this leads to wasted cpu cycles during writeback

2) bumping nr_to_write can wrap if we started with LONG_MAX
   - Not sure of all ramifications, but nr_to_write = -8 can't be good

-Eric
