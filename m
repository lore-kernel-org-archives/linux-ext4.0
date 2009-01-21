From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Wed, 21 Jan 2009 12:10:18 -0800
Message-ID: <1232568618.16682.20.camel@jamoon.sc.intel.com>
References: <20090110003645.GA16107@linux-os.sc.intel.com>
	 <20090113164842.c6aa7095.akpm@linux-foundation.org>
	 <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com>
	 <20090114044059.GA6222@mit.edu>
	 <20090114191632.GA13114@linux-os.sc.intel.com>
	 <1231961377.14825.51.camel@laptop>  <20090114212038.GJ6222@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Nick Piggin <nickpiggin@yahoo.com.au>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZAUUN1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jan 2009 15:13:27 -0500
In-Reply-To: <20090114212038.GJ6222@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-01-14 at 13:20 -0800, Theodore Tso wrote:
> On Wed, Jan 14, 2009 at 08:29:37PM +0100, Peter Zijlstra wrote:
> > > 38d47c1b7075bd7ec3881141bb3629da58f88dab is first bad commit
> > > commit 38d47c1b7075bd7ec3881141bb3629da58f88dab
> > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date:   Fri Sep 26 19:32:20 2008 +0200
> > >
> > >     futex: rely on get_user_pages() for shared futexes
> > >
> > >     On the way of getting rid of the mmap_sem requirement for sha=
red futexes,
> > >     start by relying on get_user_pages().
> > >
> > >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > >     Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
> > >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > >
> > However does a futex change make ext3 crap its pants?
>=20
> I agree, this doesn't make much sense.  I've looked at the patch, and
> I don't see how this would cause an ext3 orphaned-inode list handling
> problem
>=20
> Are you sure the bisect was done correctly?  Have you tried reverting
> that one commit, or otherwise conclusively shown that a kernel with
> this commit fails, and one without this commit works just fine?
>=20

Unfortunately, I cannot revert this patch alone from upstream git.
But I consistently see
upstream git: Always produces this oops on reboot
checkout of =EF=BB=BF38d47c1b: Always produces this oops on reboot
checkout of =EF=BB=BF=EF=BB=BF94aca1da (one patch before the above comm=
it): Reboots fine
without the oops.

This is petty specific to the particular userspace, looks like.
I only see this on SLES10 installation. Also, I need a non-root user
logged in at least once after boot through X to see this problem. I was
always seeing this as I had autologin on local terminal and was remotel=
y
rebooting the system. If I just boot to init 3 or boot to init 5 with n=
o
user logged in or boot to init 5 with root logged in, I do not see this
problem.

Thanks,
Venki

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
