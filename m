From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Date: Fri, 16 Mar 2007 17:17:04 +0100
Message-ID: <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:64070 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965464AbXCPQSm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Mar 2007 12:18:42 -0400
Content-Disposition: inline
In-Reply-To: <20070316143101.GA10152@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> on s390, and thus the delay. While I try to get it right on s390(x), we
> thought of posting this patch, so that we can save some time. Parallely
> we will work on getting the patch work on s390, and probably it will
> come as a separate patch.
> 
> +asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> +{

There is something here that will not work on s390 (31bit): the arguments
would end up in:
fd -> r2
mode -> r3
offset -> r4 + r5
len -> r6 + second halve on stack

But the s390 ABI says that a long long will be put into two consecutive
registers if the first register is smaller than 6, or it will be put
completely on the stack. So both 32 bit parts of len will end up on the
stack. That would make it a syscall with seven arguments which we currently
don't support on s390. There is no way to access the second half of len
from kernel space and that is why it is not working for you.
So you either rearrange the parameters or convert the loff_t's to pointers.

e.g.

asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len, int mode)

would work even on s390 ;)
