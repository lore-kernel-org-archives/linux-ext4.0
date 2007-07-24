From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: New e2fsprog doc on the ext4 wiki page.
Date: Tue, 24 Jul 2007 11:07:41 -0500
Message-ID: <20070724110741.65ade06e@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42734 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbXGXQJk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2007 12:09:40 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6OGAs8V022273
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2007 12:10:54 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6OG9dTT395060
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2007 12:09:39 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6OG9dr1028161
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2007 12:09:39 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l6OG9clc028131
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2007 12:09:39 -0400
Received: from rx8 (rx8.austin.ibm.com [9.41.41.30])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l6OG9cpF026270
	for <linux-ext4@vger.kernel.org>; Tue, 24 Jul 2007 11:09:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi folks

As discussed in the conference call, we are going to create a new doc
on the ext4 wiki dedicated to track the development of some of the
features needed in e2fsprogs.  The page will consist of mostly changes
needed in order to keep e2fsprogs up to date with mainline ext4 kernel
code.

I don't plan to add bug fixes, cleanup or trivial changes to the page
as this would make it hard to keep the page up to date.  The link to
the page will be:

http://ext4.wiki.kernel.org/index.php?title=E2fsprogs_features_and_patches&action=edit

Comments on what you would like to see of this page or in the initial
list of features I have gather below are welcome. 


Undo I/O manager:
-Patches submited to the mailing list by Aneesh Kumar
-To be merged after 1.40
http://thread.gmane.org/gmane.comp.file-systems.ext4/2826

64bit blk Support:
- Patches submited to the mailing list by Valerie Clement
- Requires different binaries for doing 64bit support.
- Unified binaries will most likely require API/ABI changes.
- 64bit blk support requires 64bit binaries.  Breaks on PPC64
32bit user-space env.
- Ted T'so suggests a different approach:
      http://thread.gmane.org/gmane.comp.file-systems.ext4/2845
http://thread.gmane.org/gmane.comp.file-systems.ext4/2125

Uninitialized block groups:
- Girish Shilamkar recently submited new patch to the mailing list
- Kernel patches not in mainline yet.  What's the hold up here?
- No archive link yet.

i_version support:
- Kernel patches not in mainline yet.  Ongoing discussions.
- Patches submitted?

ext4migrate:
- Patches submited to the mailing list by Aneesh Kumar
http://thread.gmane.org/gmane.comp.file-systems.ext4/1395

Extents support:
- Patches submitted?

Nano second support:
- Patches submitted?

Greater than 32000 subdir support:
- Girish Shilamkar recently submited new patch to the mailing list
- No archive link yet.


-JRS
