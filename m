From: Vasily Averin <vvs@sw.ru>
Subject: How Inactive may be much greather than cached?
Date: Thu, 18 Oct 2007 10:24:04 +0400
Message-ID: <4716FC04.6070107@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Cc: devel@openvz.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:20310 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbXJRGYM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 02:24:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

could anybody explain how "inactive" may be much greater than "cached"?
stress test (http://weather.ou.edu/~apw/projects/stress/) that writes into
removed files in cycle puts the node to the following state:

MemTotal: 16401648 kB
MemFree: 636644 kB
Buffers: 1122556 kB
Cached: 362880 kB
SwapCached: 700 kB
Active: 1604180 kB
Inactive: 13609828 kB

At the first glance memory should be freed on file closing, nobody refers to
file and ext3_delete_inode() truncates inode. We can see that memory is go away
from "cached", however could somebody explain why it become "invalid" instead be
freed? Who holds the references to these pages?

thank you,
	Vasily Averin
