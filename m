From: Eric Sandeen <sandeen@redhat.com>
Subject: e2fsck -y says "yes" to "Abort?"
Date: Sat, 18 Apr 2009 09:10:50 -0500
Message-ID: <49E9DF6A.1090000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbZDROKw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 10:10:52 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n3IEAqaW004811
	for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2009 10:10:52 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3IEApcl014666
	for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2009 10:10:51 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n3IEAo3G023874
	for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2009 10:10:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've got this bug filed against Fedora:

Bug 484913 -  Change verbage of e2fsck questioning to make the "-y"
switch more useful

and I think he has a point:

sh-3.2# e2fsck -y /dev/VolGroup00/VolVol02
e2fsck 1.41.3 (12-Oct-2008)
The filesystem size (according to the superblock) is 14090240 blocks
The physical size of the device is 8847360 blocks
Either the superblock or the partition table is likely to be corrupt!

Abort? yes

sh-3.2#

I'm reluctant to invert the logic of the Abort? question as suggested
("Are you sure you want to continue?") because this is a significant
enough problem that we probably should really pause for consideration.

But it seems like perhaps stopping at "Abort?", allowing the user to say
"n" to that and then let the "-y" flag take over from there would be
reasonable.

If this sounds ok I'll whip up a patch, something like a way to flag the
really serious questions (?) as unaffected by -y.

Thanks,
-Eric
