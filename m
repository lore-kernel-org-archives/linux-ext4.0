From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Wed, 14 Jan 2009 11:16:32 -0800
Message-ID: <20090114191632.GA13114@linux-os.sc.intel.com>
References: <20090110003645.GA16107@linux-os.sc.intel.com> <20090113164842.c6aa7095.akpm@linux-foundation.org> <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com> <20090114044059.GA6222@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Peter Zij
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64024 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbZANTQe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 14:16:34 -0500
Content-Disposition: inline
In-Reply-To: <20090114044059.GA6222@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 13, 2009 at 08:40:59PM -0800, Theodore Tso wrote:
> On Wed, Jan 14, 2009 at 02:48:13AM +0000, Arjan van de Ven wrote:
> >> Well, Arjan's commit, efaee192: "async: make the final inode deletion
> >> an asynchronous event", does change how inodes get deleted, and this
> >> looks like a race where an inode is getting deleted during the umount.
> >>
> >> So I would try reverting commit efaee192 and see if it fixes things
> >> before starting a full bisect...
> >
> > the commit is already reverted before rc1
> >
> 
> Ah, right.  I see, the async infrastructure is still in fs/super.c,
> but the actual code to insert deleted inodes onto the s_async_list was
> removed in commit b32714b.  Sorry, that confused me.
> 
> OK, so assuming that Venkatesh was using something post-rc1, I can't
> suggest anything other than a full bisect.  Sorry....
> 

Below is the result of full bisect

38d47c1b7075bd7ec3881141bb3629da58f88dab is first bad commit
commit 38d47c1b7075bd7ec3881141bb3629da58f88dab
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Sep 26 19:32:20 2008 +0200

    futex: rely on get_user_pages() for shared futexes
    
    On the way of getting rid of the mmap_sem requirement for shared futexes,
    start by relying on get_user_pages().
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 029e79e0a7421438c2a7437dd210a1acf40b6c29 b581716762c1952c0f515fac642690514e7224b7 M      include
:040000 040000 5f604b60974dbb9b0ac1a0910234f28c43a5e691 10c576cabe7eae661501ec38861a0f7488d5353b M      kernel

--
git-bisect start
# good: [4a6908a3a050aacc9c3a2f36b276b46c0629ad91] Linux 2.6.28
git-bisect good 4a6908a3a050aacc9c3a2f36b276b46c0629ad91
# bad: [c59765042f53a79a7a65585042ff463b69cb248c] Linux 2.6.29-rc1
git-bisect bad c59765042f53a79a7a65585042ff463b69cb248c
# bad: [590cf28580c999c8ba70dc39b40bab09d69e2630] Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
git-bisect bad 590cf28580c999c8ba70dc39b40bab09d69e2630
# good: [0191b625ca5a46206d2fb862bb08f36f2fcb3b31] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6
git-bisect good 0191b625ca5a46206d2fb862bb08f36f2fcb3b31
# good: [134179823b3ca9c8b98e0631906459dbb022ff9b] V4L/DVB (10130): use USB API functions rather than constants
git-bisect good 134179823b3ca9c8b98e0631906459dbb022ff9b
# good: [47992cbdaef2f18a47871b2ed01ad27f568c8b73] Merge branch 'for-rmk' of git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6 into devel
git-bisect good 47992cbdaef2f18a47871b2ed01ad27f568c8b73
# bad: [6de71484cf9561edb45224f659a9db38b6056d5e] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next-2.6
git-bisect bad 6de71484cf9561edb45224f659a9db38b6056d5e
# bad: [179475a3b46f86e2d06f83e2312218ac3f0cf3a7] Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git-bisect bad 179475a3b46f86e2d06f83e2312218ac3f0cf3a7
# bad: [cc37d3d20604f3759d269247b022616f710aa52d] Merge branch 'core/futexes' into core/core
git-bisect bad cc37d3d20604f3759d269247b022616f710aa52d
# good: [7918baa555140989eeee1270f48533987d48fdba] mutex: __used is needed for function referenced only from inline asm
git-bisect good 7918baa555140989eeee1270f48533987d48fdba
# bad: [b19b3c74c7bbec45a848631b8f970ac110665a01] Merge branches 'core/debug', 'core/futexes', 'core/locking', 'core/rcu', 'core/signal', 'core/urgent' and 'core/xen' into core/core
git-bisect bad b19b3c74c7bbec45a848631b8f970ac110665a01
# bad: [42569c39917a08e8de1e8b5685463be7b74baebd] futex: fixup get_futex_key() for private futexes
git-bisect bad 42569c39917a08e8de1e8b5685463be7b74baebd
# bad: [61270708ecf1cda148e84fbf6e0703ee5aa81814] futex: reduce mmap_sem usage
git-bisect bad 61270708ecf1cda148e84fbf6e0703ee5aa81814
# bad: [38d47c1b7075bd7ec3881141bb3629da58f88dab] futex: rely on get_user_pages() for shared futexes
git-bisect bad 38d47c1b7075bd7ec3881141bb3629da58f88dab
---


