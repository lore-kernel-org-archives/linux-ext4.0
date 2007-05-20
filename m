From: Chris Lee <cslee-list@cybericom.co.uk>
Subject: A feature??
Date: Sun, 20 May 2007 09:51:14 +0100
Message-ID: <46500C02.3010802@cybericom.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nildram.co.uk ([195.149.33.74]:33682 "EHLO
	smtp.nildram.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXETJZh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 May 2007 05:25:37 -0400
Received: from [10.10.10.226] (leenet.gotadsl.co.uk [82.133.126.77])
	by smtp.nildram.co.uk (Postfix) with ESMTP id 049834DB2C
	for <linux-ext4@vger.kernel.org>; Sun, 20 May 2007 09:51:14 +0100 (BST)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I am not a FS guru so please tell me where to get off if I sound stupid.
After lurking for some time I have come up with something that may be of 
interest as a feature:

If EXT4 were to pr-allocate a configurable amount of space for a special file 
and then use that file as a new EXT4 partition;
-Use that file for all new writes to disk
-Any changed files are changed by writing the change to this file, or the whole 
changed file, whichever is more efficient end to end.
-A section of the file includes tracking of files that need modification in the 
actual FS.
-Then when the disk is put back into normal read write mode the FS data in the 
file just needs to be worked into the actual FS.

This way the FS could be put into suspended operation while a third party reads it.
I know there are other methods like snapshots, but this works at the FS level so 
that the third party, which obviously needs to know ext4, can access the hard 
drive directly.

Chris.
