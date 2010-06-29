From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file
 stats available
Date: Tue, 29 Jun 2010 15:48:59 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1006291542400.5576@cobra.newdream.net>
References: <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com>
 <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
 <20100629200315.23196.68742.stgit@warthog.procyon.org.uk> <26026.1277851016@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ulrich Drepper <drepper@gmail.com>, viro@zeniv.linux.org.uk,
	smfrench@gmail.com, jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <26026.1277851016@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 29 Jun 2010, David Howells wrote:
> Ulrich Drepper <drepper@gmail.com> wrote:
> 
> > On Tue, Jun 29, 2010 at 13:03, David Howells <dhowells@redhat.com> wrote:
> > > Add a pair of system calls to make extended file stats available,
> > > including file creation time, inode version and data version where
> > > available through the underlying filesystem:
> > 
> > If you add something like this you might want to integrate another
> > extension.  This has been discussed a long time ago.  In almost no
> > situation all the information is needed.  Some of the pieces of
> > information returned by the syscall might be harder to collect than
> > other.
> 
> Trond mentioned this:
> 
> 	There has been a lot of interest in allowing the user to specify
> 	exactly which fields they want the filesystem to return, and whether
> 	or not the kernel can use cached data or not. The main use is to allow
> 	specification of a 'stat light' that could help speed up
> 	"readdir()+multiple stat()" type queries. At last year's Filesystem
> 	and Storage Workshop, Mark Fasheh actually came up with an initial
> 	design:
> 
> 	  http://www.kerneltrap.com/mailarchive/linux-fsdevel/2009/4/7/5427274
> 
> It'd be easy enough to absorb the functionality from that patch.

That would be nice.  HPC folks have been looking for this functionality 
for some time now.

> > It makes sense in such a situation to allow the caller to specify what she
> > is interested in.  A bitmask of some sort.
> 
> I have one of those.  See the query_flags field.  One question, though, is how
> to break things down.  Obvious groupings of the already extant stat stuff
> might be:
> 
> 	- st_dev, st_ino, st_mode, st_nlink, st_uid, st_gid, st_rdev, st_size
> 	- st_block, st_blksize
> 	- st_atime, st_mtime, st_ctime
> 
> However, what seems obvious to me might not be for some netfs or other.

The problem is that groupings that may seem logical now may not match 
reality for some specific file system for various implementation reasons.  
IMO a bit per field makes the most sense, with some simple way to include 
all fields (-1 or 0).  A mask argument that is separate from flags might 
make that simpler?

sage
