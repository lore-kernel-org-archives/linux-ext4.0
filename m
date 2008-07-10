From: Theodore Tso <tytso@mit.edu>
Subject: Re: Segfaults--they're back!
Date: Thu, 10 Jul 2008 07:02:30 -0400
Message-ID: <20080710110230.GA8603@mit.edu>
References: <3.0.6.32.20080709150004.01bd9858@pop.west.cox.net> <20080710052150.GC6764@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gary Hawco <ghawco@cox.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Mingming <cmm@us.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44234 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753264AbYGJLDG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 07:03:06 -0400
Content-Disposition: inline
In-Reply-To: <20080710052150.GC6764@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 10, 2008 at 10:51:50AM +0530, Aneesh Kumar K.V wrote:
> On Wed, Jul 09, 2008 at 03:00:04PM +0000, Gary Hawco wrote:
> > Segfaults have returned with snapshots compiled after 070908--0010hrs GMT.
> > 
> > That one worked fine.

Is this a kernel or userspace segfault?  i.e., is there a kernel oops
message?  If so, can you send us the oops message?  It's really really
useful to have it.  Also, can you send us a dumpe2fs of the filesystem
which ou were writing to?  Some of the bugs which we've been finding
are specific to a 1k block filesystem, for example, and sometimes that
can help narrow down the bug.

> Is your file system full when this happens ? Which user space call cause
> the segfault ? An strace should be able to help you find that. We
> actually have modified ext4 to give SIGBUS when we hit ENOSPC during
> mmap write. For ex:
> 
> root:/ext4# /root/mmaptest ./test4  0 100
> mmaping 0 to 100
> Bus error (core dumped)
> root:/ext4# 

What Aneesh is talking about here is a userspace core dump which is
normal, if the filesystem is full.  I'm not sure that's what you're
referring to assuming that "they're back" means you're referring to a
kernel oops.

Regards,

						- Ted
