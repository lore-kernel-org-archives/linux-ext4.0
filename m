From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] fs: only call sync_filesystem() when remounting
 read-only
Date: Thu, 13 Mar 2014 11:36:35 +1100
Message-ID: <20140313003635.GA4263@dastard>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140308160818.GC11633@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lucas Nussbaum <lucas.nussbaum@loria.fr>,
	linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org Emmanuel Jeanvoine"
	<emmanuel.jeanvoine@inria.fr>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33346 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbaCMAgi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2014 20:36:38 -0400
Content-Disposition: inline
In-Reply-To: <20140308160818.GC11633@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 08, 2014 at 11:08:18AM -0500, Theodore Ts'o wrote:
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
> 
> Folks on linux-fsdevel, any objections if I carry this patch in the
> ext4 tree?  I don't think it should cause problems for other file
> systems, since any file system that tries to rely on the implied
> syncfs() is going to be subject to races, but it might make such a
> race condition bug much more visible...

IMO, I think that you should be looking to fix ext4 syncfs issues,
not changing the VFS behaviour that might cause subtle and unnoticed
problems for other filesystems. We should not be moving data
inegrity operations without first auditing of all the filesystem
remount operations for issues.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
