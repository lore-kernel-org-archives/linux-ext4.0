From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
Date: Sun, 04 Sep 2011 18:19:16 -0400
Message-ID: <yq139gcymqj.fsf@sermon.lab.mkp.net>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
	<CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
	<20110902182214.GC12086@tux1.beaverton.ibm.com>
	<yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
	<6fdb58aed1dae8020900e65cbfb34b28.squirrel@www.firstfloor.org>
	<yq14o0scjmg.fsf@sermon.lab.mkp.net>
	<88f8907569619968aa7b4a8c669d5aba.squirrel@www.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	djwong@us.ibm.com, "Greg Freemyer" <greg.freemyer@gmail.com>,
	"Andreas Dilger" <adilger.kernel@dilger.ca>,
	"Theodore Tso" <tytso@mit.edu>,
	"Sunil Mushran" <sunil.mushran@oracle.com>,
	"Amir Goldstein" <amir73il@gmail.com>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"Mingming Cao" <cmm@us.ibm.com>,
	"Joel Becker" <jlbec@evilplan.org>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Coly Li" <colyli@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:52889 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1IDWUT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Sep 2011 18:20:19 -0400
In-Reply-To: <88f8907569619968aa7b4a8c669d5aba.squirrel@www.firstfloor.org>
	(Andi Kleen's message of "Sun, 4 Sep 2011 19:44:55 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Andi" == Andi Kleen <andi@firstfloor.org> writes:

Andi> Doesn't have any performance numbers.

It's been a while since I read them. I thought they had some compelling
numbers. Anyway, made a big difference in real life testing here. For
sustained I/O we're talking an order of magnitude.


Andi> You need to keep in mind that PCLMULQDQ uses FPU state, so any
Andi> speedup for the kernel must be large enough to amortize the cost
Andi> of saving the FPU state.

Yeah, my test cases were for bulk database I/O, not for writing a
handful of fs metadata blocks. Plus for the DB tests the CRC was
generated in userland.

I seem to recall Joel picking something other than the hw-accelerated
CRC32C for ocfs2 metadata and that didn't cause any problems.

That said, I do see a difference between IP checksum and CRC on normal
FS workloads with DIX enabled here.


Andi> Typically that only works out for quite large buffers, but kernel
Andi> buffers are relatively small.

*nod*

-- 
Martin K. Petersen	Oracle Linux Engineering
