From: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Subject: Re: [PATCH, RFC] fs: only call sync_filesystem() when remounting
 read-only
Date: Mon, 10 Mar 2014 12:45:08 +0100
Message-ID: <20140310114508.GA28107@xanadu.blop.info>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140308160818.GC11633@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org Emmanuel Jeanvoine"
	<emmanuel.jeanvoine@inria.fr>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xanadu.blop.info ([178.79.145.134]:35848 "EHLO xanadu.blop.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaCJMId (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Mar 2014 08:08:33 -0400
Content-Disposition: inline
In-Reply-To: <20140308160818.GC11633@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/03/14 at 11:08 -0500, Theodore Ts'o wrote:
> On Wed, Mar 05, 2014 at 03:13:43PM +0100, Lucas Nussbaum wrote:
> > TL;DR: we experience long temporary hangs when doing multiple mount -o
> > remount at the same time as other I/O on an ext4 filesystem.
> > 
> > When starting hundreds of LXC containers simultaneously on a system, the
> > boot of some containers was hanging. We tracked this down to an
> > initscript's use of mount -o remount, which was hanging in D state.
> > 
> > We reproduced the problem outside of LXC, with the script available at
> > [0]. That script initiates 1000 mount -o remount, and performs some
> > writes using a big cp to the same filesystem during the remounts....
> 
> +linux-fsdevel since the patch modifies fs/super.c
> 
> Lukas, can you try this patch?  I'm pretty sure this is what's going
> on.  It turns out each "mount -o remount" is implying an fsync(), so
> your test case is identical to copying a large file while having
> thousand of processes calling syncfs() on the file system, with the
> predictable results.

Hi Ted,

I can confirm that:
1) the patch solves my problem
2) issuing 'sync' instead of 'mount -o remount' indeed exhibits the
   problem again

However, I'm curious: why would such a workload (multiple syncfs()
initiated during a write) block for several minutes on an ext4
filesystem? I've just tried again on ext3, and it's not a problem in
that case.

Lucas
