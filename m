From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Ext4 Interlock meeting minutes
Date: Mon, 14 Apr 2008 17:39:34 -0500
Message-ID: <20080414173934.230cd913@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50290 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbYDNWj4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Apr 2008 18:39:56 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3EMdtwR025296
	for <linux-ext4@vger.kernel.org>; Mon, 14 Apr 2008 18:39:55 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3EMdtoi251666
	for <linux-ext4@vger.kernel.org>; Mon, 14 Apr 2008 18:39:55 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3EMdtaJ004737
	for <linux-ext4@vger.kernel.org>; Mon, 14 Apr 2008 18:39:55 -0400
Received: from gara.konoha.net (wecm-9-67-160-152.wecm.ibm.com [9.67.160.152])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m3EMdswY004732
	for <linux-ext4@vger.kernel.org>; Mon, 14 Apr 2008 18:39:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folk,

Mingming asked me to write up some meeting minutes.  I did not take
notes so I might have miss/missremember something/someone.


Attendees:  
==========
Mingming Cao, Andreas Dilger, Ted T'so, Takashi Sato, Eric Sandeen,
Valerie Clement, Solofo Ramangalahy, Aneesh Kumar K.V

OLS
===
- Aneesh talked about the paper due tomorrows.  He will send out copes
of the paper for review.

Patch queue
- Mingming said something about the patch queue but I did not take
notes. :(

Uninit_groups
=============
- Ted ask if anybody was looking into kernel background thread for
zeroing inode tables in uninit_groups.

- Ted talks about possibly renaming the uninit_groups feature for it
being somewhat misleading since inode tables are zeroed when the
feature is used.

- Fast mke2fs will not be possible if there is no background thread
for zeroing out inode tables as this could be dangerous if csum are
corrupted.  Andreas mentioned that fast mkfs was never publicly
advertised as the main benefit from uninit_groups.

- Ted has declare lazy_bg a horrible hack and thinks of completely
removing it from e2fsprogs to avoid people developing on top of it.

- Flex_bg seems to be exposing some of the issues that need to be
avoided with regards to lazy_bg and uninit_groups.  The return value
of ext2fs_super_and_bgd_loc() is not to be trusted and should not be
use anywhere execpt mke2fs.  This needs to be documented in the code to
ensure no one else expects accurate results from this routine.

Flex_bg
=======
- Some folk on the call just found out today that the flex_bg inode
allocator does not spread inodes the way Orlov does.  My hat's off to
Andreas which seemed like the only one in the call who actually read the
patch. :)

- Ted is concerned about the possible fragmentation effects that this
could have on an aged file system.  Jose mentioned that the allocator
does have some code to help in fragmentation in aging fs but agrees that
not enough testing has been done.  He also mentioned that this is
presented as a work in progress on the OLS paper for this very reason.

- Andreas talks about flagging files with a append flag to a assist
allocator algorithms when allocating blocks for such files.

- Mingming suggests moving the flex_bg patch to the unstable part of
the patch queue until it receive better testing.  Ted suggest instead
to stabilize the patch and the tools and get some brave people to test
the feature on a real life usage to see what effects it has as it ages.

BUG/Feature tracking/TO-DO list
===============================
- Talks in IRC last week point out that there seems to be some
confusion as to what things are already supported in the e2fsprogs
branches.  There is a general consensus that a TO-DO list should
probably be created to tack some of the progress being made.

- Ted mentioned that he actively uses the SourceForge bug tracker and we
could use that as a way to track features.

- A TODO list is needed to start writing stuff in SourceForge.
 

-JRS
