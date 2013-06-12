From: "jon ernst" <jonernst07@gmx.com>
Subject: xfstest ext4 'utility required' run stop
Date: Wed, 12 Jun 2013 01:36:18 -0400
Message-ID: <20130612053618.296170@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.200]:62723 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab3FLFgU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 01:36:20 -0400
Received: from mailout-us.gmx.com ([172.19.198.46]) by mrigmx.server.lan
 (mrigmxus001) with ESMTP (Nemesis) id 0Lk7fq-1UBvGj0Bcg-00c6F4 for
 <linux-ext4@vger.kernel.org>; Wed, 12 Jun 2013 07:36:19 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When I try to run xfstest 301 - 304. They all got error message "utility required, run stop, stkip this test" , test 305 is fine.
But it did not tell which utility is required. I do have test patition and scratch partition set up. And I do have e4defrag on my linux.

What could be the reason?please help.

Thanks!
