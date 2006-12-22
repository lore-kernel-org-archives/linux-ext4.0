From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC][Patch 2/2] Persistent preallocation in ext4
Date: Fri, 22 Dec 2006 18:31:03 +0300
Message-ID: <m38xh0x808.fsf@bzzz.home.net>
References: <20061205134338.GA1894@amitarora.in.ibm.com>
	<20061215123920.GB24572@amitarora.in.ibm.com>
	<20061219114251.GA25086@amitarora.in.ibm.com>
	<20061219211409.GP5937@schatzie.adilger.int>
	<20061222151615.GA5851@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com, cmm@us.ibm.com, suzuki@in.ibm.com,
	alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppp85-141-214-150.pppoe.mtu-net.ru ([85.141.214.150]:51273 "EHLO
	gw.home.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965204AbWLVQKG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Dec 2006 11:10:06 -0500
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20061222151615.GA5851@amitarora.in.ibm.com> (Amit K. Arora's
	message of "Fri\, 22 Dec 2006 20\:46\:15 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Amit K Arora (AKA) writes:

 AKA> Above we can see that block numbers from 68 to 502 are each covered by
 AKA> more than one extent (besides couple of holes, which also might be part
 AKA> of the same problem).

 AKA> Note: A "u" in extent[u] donates that this extent is
 AKA> uninitialized, and thus was created as part of preallocation and noone
 AKA> has written to it. An "i" signifies that the extent is initialized.

 AKA> I am trying to solve this issue currently. Any suggestions are more than
 AKA> welcome.. :)

I'd write a simple function that check given leaf for consistency
(in this case you need to check that every subsequent extent doesn't
overlap previous one) and add this check in few points (before and
after change). this worked very well, especially if all extents fit
single block.

thanks, Alex
