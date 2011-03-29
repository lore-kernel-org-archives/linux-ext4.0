From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: breaking ext4 to test recovery
Date: Mon, 28 Mar 2011 19:45:41 -0700
Message-ID: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wdscspam3.wdc.com ([129.253.55.42]:56645 "EHLO
	wdscspam3.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1C2C7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Mar 2011 22:59:12 -0400
Content-class: urn:content-classes:message
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I would like to be able to break our ext4 file system
(specifically corrupt the journal) to be sure that we
can automatically notice the problem and attempt an
autonomous fix.

dumpe2fs tells me the inode, but not, that I can see, the
blocks where the journal exists (for "dd"ing junk to it).

Is there any debug tool that would let me deliberately
break the file system (at least, trash the journal)?

If not, is there a hint for figuring out the block(s) of
the journal so I can stomp it?

The kernel is in an embedded machine, so it's a little old
2.6.32.11 and e2fsprogs/libs 1.41.12-2 (Lenny)

Dan Taylor
Sr. Staff Engineer
WD Branded Products
949.672.7761 
