From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Sep 10, 2007)
Date: Thu, 13 Sep 2007 10:32:10 -0500
Message-ID: <20070913103210.62e26236@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53857 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbXIMPcM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2007 11:32:12 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8DFWAli031719
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 11:32:10 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8DFWBhD687804
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 11:32:11 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8DFWAFR001094
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 11:32:10 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l8DFWAiv001065
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 11:32:10 -0400
Received: from gara (wecm-9-67-67-49.wecm.ibm.com [9.67.67.49])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l8DFW99i041158
	for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2007 10:32:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Attendees: Dave Kleikamp, Andreas Dilger, Jose Santos, Aneesh Kumar,
Eric Sandeen

- Lack of e2fsprogs support for some of the features is viewed as the
major roadblocks for declaring ext4 stable.  There was talk about
creating a forked version of the tools to only support ext4 while we
wait for other features to be implemented in Ted's e2fsprogs tree.
The goal of this version is to provide users with the means of creating
and fsck ext4 filesystems in order to increase test coverage.  Such
version would probably not export any libraries and thus not worry
about ABI breakage issues.

- Most filesystem layout changes are already in the patch queue so
filesystem format is stable.  Other major features are in memory
changes and thus can be changed/improve/debug after dev status is
removed.

- Andres express interest in Avantika's automated testing to see if it
was possible to test different permutation of features to test breakage
of the ext4 code.

- Jose to post FLEX_BG kernel patch for inclusion into the patch
queue.  Inode and block allocation changes are memory only, so they can
be added after removal of dev status.

- Lost of talk about the process sending patches to MM before sending
patches for Linus during the merge window.  Eric pointed out that if
nobody was testing ext4 in mm, then this hole exercise is mostly a
wasted effort.  Andreas and Shaggy pointed out Andrews concerns about
patches not in mm during the last merge window.  Shaggy pointed out
that Ted's git tree is not always up to date to the latest ext4 patch
queue and that someone need to regularly maintain a git tree Andrew can
pull from.

- Even though attendance was low Andreas suggested that a meeting
notice be sent since a lot of good discussion was made.  Everybody
agree but, nobody took meeting notes and nobody volunteered. :)

Apologies if I left out something important.

-JRS
