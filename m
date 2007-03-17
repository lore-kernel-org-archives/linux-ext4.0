From: Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Date: Sat, 17 Mar 2007 20:59:05 +1100
Message-ID: <17915.48105.70494.958220@cargo.ozlabs.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:35833 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933691AbXCQKFy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Mar 2007 06:05:54 -0400
In-Reply-To: <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Heiko Carstens writes:

> So you either rearrange the parameters or convert the loff_t's to pointers.
> 
> e.g.
> 
> asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len, int mode)
> 
> would work even on s390 ;)

... but wouldn't work on 32-bit powerpc. :(  We would end up with a
pad argument between fd and offset, giving 7 arguments in all
(counting the loff_t's as 2), but we only support 6.

Paul.
