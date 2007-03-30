From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Interface for the new fallocate() system call
Date: Fri, 30 Mar 2007 09:19:29 +0200
Message-ID: <20070330071929.GC8365@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:6500 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbXC3HTc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Mar 2007 03:19:32 -0400
Content-Disposition: inline
In-Reply-To: <20070329101010.7a2b8783.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> > Even ARM prefers above kind of layout. For details please see the
> > definition of sys_arm_sync_file_range().
> 
> This is a clean-looking option.  Can s390 be changed to support seven-arg
> syscalls?
> 
> > Option of loff_t => high u32 + low u32
> > --------------------------------------
> > Matthew and Russell have suggested another option of breaking each
> > "loff_t" into two "u32"s. This will result in 6 arguments in total.
> > 
> > Following think that this is a good alternative:
> > Matthew Wilcox, Russell King, Heiko Carstens
> > 
> > Following do not like this idea:
> > Chris Wedgwood
> 
> It's a bit weird-looking, but the six-32-bit-args approach is simple
> enought to understand and implement.  Presumably the glibc wrapper
> would hide that detail from everyone.

s390 can be changed to support seven-arg syscalls. But that would require
creating an additional stackframe in *libc to save original register
contents and in addition it would make our syscall hotpath slower.
That is because we have to take care of an additional register that might
contain user space passed contents and needs to be put on the kernel stack.
If possible I'd prefer the six-32-bit-args approach.
