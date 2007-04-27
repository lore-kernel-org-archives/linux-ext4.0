From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 0/5] fallocate system call
Date: Fri, 27 Apr 2007 14:10:03 +0200
Message-ID: <20070427121003.GA7808@osiris.boeblingen.de.ibm.com>
References: <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:16376 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbXD0MKn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Apr 2007 08:10:43 -0400
Content-Disposition: inline
In-Reply-To: <20070426175056.GA25321@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 26, 2007 at 11:20:56PM +0530, Amit K. Arora wrote:
> Based on the discussion, this new patchset uses following as the
> interface for fallocate() system call:
> 
>  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> 
> It seems that only s390 architecture has a problem with such a layout of
> arguments in fallocate(). Thus for s390, we plan to have a wrapper
> (say, sys_s390_fallocate()) for the sys_fallocate(), which will get
> called by glibc when an application issues a fallocate() system call
> on s390. The s390 arch specific changes will be part of a separate
> patch (PATCH 2/5). It will be great if some s390 expert can verify the
> patch, since I have not been able to test it on s390 so far.

After long discussions where at least two possible implementations
were suggested that would work on _all_ architectures you chose one
which doesn't and causes extra effort.

> It was also noted that minor changes might be required to strace code
> to take care of "different arguments on s390" issue.

This is not limited to strace...

Besides that the s390 backend looks ok.
