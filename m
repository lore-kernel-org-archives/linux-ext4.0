From: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Subject: Re: [PATCH, RFC] fs: only call sync_filesystem() when remounting
 read-only
Date: Mon, 10 Mar 2014 13:15:03 +0100
Message-ID: <20140310121503.GA31797@xanadu.blop.info>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140308160818.GC11633@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org Emmanuel Jeanvoine"
	<emmanuel.jeanvoine@inria.fr>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xanadu.blop.info ([178.79.145.134]:35931 "EHLO xanadu.blop.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbaCJMPO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Mar 2014 08:15:14 -0400
Content-Disposition: inline
In-Reply-To: <20140308160818.GC11633@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

That Cc: line:
Cc: linux-ext4@vger.kernel.org, "linux-fsdevel@vger.kernel.org Emmanuel Jeanvoine" <emmanuel.jeanvoine@inria.fr>
sounds wrong. You might want to re-send to linux-fsdevel@.

Thanks

Lucas

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
> 
> Folks on linux-fsdevel, any objections if I carry this patch in the
> ext4 tree?  I don't think it should cause problems for other file
> systems, since any file system that tries to rely on the implied
> syncfs() is going to be subject to races, but it might make such a
> race condition bug much more visible...
> 
> 					- Ted
> 
> commit 8862c3c69acc205b59b00baed67e50446e2fd093
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sat Mar 8 11:05:35 2014 -0500
> 
>     fs: only call sync_filesystem() when remounting read-only
>     
>     Currently "mount -o remount" always implies an syncfs() on the file
>     system.  This can cause a problem if a workload calls "mount -o
>     remount" many, many times while concurrent I/O is happening:
>     
>        http://article.gmane.org/gmane.comp.file-systems.ext4/42876
>     
>     Whether it would ever be sane for a workload to call "mount -o
>     remount" gazillions of times when they are effectively no-ops, it
>     seems stupid for a remount to imply an fsync().
>     
>     It's possible that there is some file system which is relying on the
>     implied fsync(), but that's arguably broken, since aside for the
>     remount read-only case, there's nothing that will prevent other writes
>     from sneaking in between the sync_filesystem() and the call to
>     sb->s_op->remount_fs().
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/super.c b/fs/super.c
> index 80d5cf2..0fc87ac 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -717,10 +717,9 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>  			if (retval)
>  				return retval;
>  		}
> +		sync_filesystem(sb);
>  	}
>  
> -	sync_filesystem(sb);
> -
>  	if (sb->s_op->remount_fs) {
>  		retval = sb->s_op->remount_fs(sb, &flags, data);
>  		if (retval) {
> 

-- 
| Lucas Nussbaum      Assistant professor @ Univ. de Lorraine |
| lucas.nussbaum@loria.fr                   LORIA / AlGorille |
| http://www.loria.fr/~lnussbau/            +33 3 54 95 86 19 |
