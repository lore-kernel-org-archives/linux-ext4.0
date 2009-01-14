From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Wed, 14 Jan 2009 20:29:37 +0100
Message-ID: <1231961377.14825.51.camel@laptop>
References: <20090110003645.GA16107@linux-os.sc.intel.com>
	 <20090113164842.c6aa7095.akpm@linux-foundation.org>
	 <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com>
	 <20090114044059.GA6222@mit.edu>
	 <20090114191632.GA13114@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>,
	Nick Piggin <nickpiggin@yahoo.com.au>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZANT3z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Jan 2009 14:29:55 -0500
In-Reply-To: <20090114191632.GA13114@linux-os.sc.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-01-14 at 11:16 -0800, Pallipadi, Venkatesh wrote:
> On Tue, Jan 13, 2009 at 08:40:59PM -0800, Theodore Tso wrote:
> > On Wed, Jan 14, 2009 at 02:48:13AM +0000, Arjan van de Ven wrote:
> > >> Well, Arjan's commit, efaee192: "async: make the final inode deletion
> > >> an asynchronous event", does change how inodes get deleted, and this
> > >> looks like a race where an inode is getting deleted during the umount.
> > >>
> > >> So I would try reverting commit efaee192 and see if it fixes things
> > >> before starting a full bisect...
> > >
> > > the commit is already reverted before rc1
> > >
> > 
> > Ah, right.  I see, the async infrastructure is still in fs/super.c,
> > but the actual code to insert deleted inodes onto the s_async_list was
> > removed in commit b32714b.  Sorry, that confused me.
> > 
> > OK, so assuming that Venkatesh was using something post-rc1, I can't
> > suggest anything other than a full bisect.  Sorry....
> > 
> 
> Below is the result of full bisect
> 
> 38d47c1b7075bd7ec3881141bb3629da58f88dab is first bad commit
> commit 38d47c1b7075bd7ec3881141bb3629da58f88dab
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Sep 26 19:32:20 2008 +0200
> 
>     futex: rely on get_user_pages() for shared futexes
>     
>     On the way of getting rid of the mmap_sem requirement for shared futexes,
>     start by relying on get_user_pages().
>     
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> :040000 040000 029e79e0a7421438c2a7437dd210a1acf40b6c29 b581716762c1952c0f515fac642690514e7224b7 M      include
> :040000 040000 5f604b60974dbb9b0ac1a0910234f28c43a5e691 10c576cabe7eae661501ec38861a0f7488d5353b M      kernel

However does a futex change make ext3 crap its pants?

Is there anything more to it than start the machine, and reboot?

