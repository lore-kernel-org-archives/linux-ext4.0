From: "Jayson R. King" <dev@jaysonking.com>
Subject: [PATCH 2.6.27.y 0/3] ext4 fixes
Date: Fri, 28 May 2010 14:24:56 -0500
Message-ID: <4C001888.8020006@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Jayson R. King" <dev@jaysonking.com>,
	Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
To: Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout10.eigbox.net ([66.96.184.10]:51033 "EHLO
	bosmailout10.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab0E1UGI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 16:06:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greetings,

This is a second try at sending ext4 fixes to 2.6.27.y, including an
important deadlock fix from kernel bugzilla #12579. The patches were
dropped the first time because they depended on a vfs patch which was
recently found to be broken on mainline. Now, the vfs patch is not
included in this set, only ext4 patches.

Here are the three patches I'm proposing for inclusion in 2.6.27.y:

Theodore Ts'o (1):
      ext4: Use our own write_cache_pages()

Aneesh Kumar K.V (2):
      ext4: Fix file fragmentation during large file write.
      ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages

They will be posted as replies to this message.

I have made some changes to the first two patches to adapt them for the
current 2.6.27.47 tree. The changes are detailed between brackets above
my signed-off line for each.

Jayson


