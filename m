From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Interface for the new fallocate() system call
Date: Thu, 29 Mar 2007 11:37:03 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0703291134070.6730@woody.linux-foundation.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
 <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
 <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
 <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com>
 <20070329115126.GB7374@amitarora.in.ibm.com> <Pine.LNX.4.61.0703291854000.31834@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0703291314330.4366@chaos.analogic.com>
 <Pine.LNX.4.61.0703292002210.31834@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35533 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933663AbXC2Sku (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Mar 2007 14:40:50 -0400
In-Reply-To: <Pine.LNX.4.61.0703292002210.31834@yvahk01.tjqt.qr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Thu, 29 Mar 2007, Jan Engelhardt wrote:
>
> I have to disagree, since wrapping it into a struct and copying the struct
> in kernelspace from userspace requires more code.

Not just more code, but more security issues too.

Passing system call arguments by value means that there are no subtle 
security issues - the value you use is the value you got. But once you 
pass-by-reference, you have to make damn sure that you do the proper user 
space accesses and verify the pointer correctly.

User-space (aka "user-supplied") pointers are just more dangerous. We 
obviously can't avoid them, but they need much more care than just a 
random value directly passed in a register.

		Linus
