From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Updated ext4 quota design document
Date: Mon, 21 Jun 2010 08:29:06 -0400
Message-ID: <E1OQg7e-0001mI-AB@closure.thunk.org>
To: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42902 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0FUM3I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jun 2010 08:29:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've created an updated quota design document here:

https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_Ext4

No major changes from last time.

One new thing is a proposed (optional) change to the quota format,
to use the 32-bit dqpb_pad field in the v2r1 on-disk quota structure as
a 32-bit CRC of the quota entry.  This would allow the quota system to
detect corrupted quota entries.  Jan, what do you think?

       		       		      	      - Ted


