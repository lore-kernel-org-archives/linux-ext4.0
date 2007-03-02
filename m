From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Fri, 02 Mar 2007 08:13:00 -0800
Message-ID: <1172851980.9213.13.camel@dyn9047017100.beaverton.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	 <20070225022326.137b4875.akpm@linux-foundation.org>
	 <20070301183445.GA7911@amitarora.in.ibm.com> <45E7BE4B.5070602@us.ibm.com>
	 <45E83FCE.4040008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:39887 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992569AbXCBQNc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2007 11:13:32 -0500
In-Reply-To: <45E83FCE.4040008@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-03-02 at 09:16 -0600, Eric Sandeen wrote:
> Badari Pulavarty wrote:
> > 
> > Amit K. Arora wrote:
> > 
> >> This is to give a heads up on few patches that we will be soon coming up
> >> with. These patches implement a new system call sys_fallocate() and a
> >> new inode operation "fallocate", for persistent preallocation. The new
> >> system call, as Andrew suggested, will look like:
> >>
> >>  asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
> >>
> > I am wondering about return values from this syscall ? Is it supposed to 
> > return the
> > number of bytes allocated ? What about partial allocations ? 
> 
> If you don't have enough blocks to cover the request, you should 
> probably just return -ENOSPC, not a partial allocation.

That could be challenging, when multiple writers are working in
parallel. You may not be able to return -ENOSPC, till you fail the
allocation (for filesystems which alllocates a block at a time).

> 
> > What about 
> > if the
> > blocks already exists ? What would be return values in those cases ?
> 
> 0 on success, other normal errors oetherwise..
> 
> If asked for a range that includes already-allocated blocks, you just 
> allocate any non-allocated blocks in the range, I think.

Yes. What I was trying to figure out is, if there is a requirement that
interface need to return exact number of bytes it *really* allocated
(like write() or read()). I can't think of any, but just wanted to
through it out..

BTW, what is the interface for finding out what is the size of the
pre-allocated file ? 

Thanks,
Badari
