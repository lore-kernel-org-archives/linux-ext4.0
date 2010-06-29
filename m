From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available
Date: Tue, 29 Jun 2010 23:36:56 +0100
Message-ID: <26026.1277851016@redhat.com>
References: <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk> <20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, smfrench@gmail.com,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Ulrich Drepper <drepper@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab0F2WhI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jun 2010 18:37:08 -0400
In-Reply-To: <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ulrich Drepper <drepper@gmail.com> wrote:

> On Tue, Jun 29, 2010 at 13:03, David Howells <dhowells@redhat.com> wrote:
> > Add a pair of system calls to make extended file stats available,
> > including file creation time, inode version and data version where
> > available through the underlying filesystem:
> 
> If you add something like this you might want to integrate another
> extension.  This has been discussed a long time ago.  In almost no
> situation all the information is needed.  Some of the pieces of
> information returned by the syscall might be harder to collect than
> other.

Trond mentioned this:

	There has been a lot of interest in allowing the user to specify
	exactly which fields they want the filesystem to return, and whether
	or not the kernel can use cached data or not. The main use is to allow
	specification of a 'stat light' that could help speed up
	"readdir()+multiple stat()" type queries. At last year's Filesystem
	and Storage Workshop, Mark Fasheh actually came up with an initial
	design:

	  http://www.kerneltrap.com/mailarchive/linux-fsdevel/2009/4/7/5427274

It'd be easy enough to absorb the functionality from that patch.

> It makes sense in such a situation to allow the caller to specify what she
> is interested in.  A bitmask of some sort.

I have one of those.  See the query_flags field.  One question, though, is how
to break things down.  Obvious groupings of the already extant stat stuff
might be:

	- st_dev, st_ino, st_mode, st_nlink, st_uid, st_gid, st_rdev, st_size
	- st_block, st_blksize
	- st_atime, st_mtime, st_ctime

However, what seems obvious to me might not be for some netfs or other.

> For this the syscall interface should have a parameter to specify what
> is requested and the stat-like structure should have a field
> specifying what is actually present.  The latter bitmask must be a
> superset of the former.

Got that.

> Previous discussions centered around reusing the stat data structure
> and somehow make it work.  But no clean solution was found.  If a new
> structure is added anyway this could solve the issue.

That's what I thought.  Linux has a tangled mess of stat structs:-/

> And while you're at it, maybe some spare fields at the end are nice.

I made it so that the syscall can return variable length data: the main xstat
struct, plus extra records yet to be defined.  They could even be variable
length and assembled/disassembled with something like the control message
macros for recvmsg().

David
