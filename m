From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC, PATCH,
 RESEND] fs: push rcu_barrier() from deactivate_locked_super() to
 filesystems
Date: Sat, 9 Jun 2012 00:25:57 -0700
Message-ID: <20120609002557.b8aba759.akpm@linux-foundation.org>
References: <1339191663-17693-1-git-send-email-kirill.shutemov@linux.intel.com>
	<20120608150253.e42464a6.akpm@linux-foundation.org>
	<20120608221446.GA18250@otc-wbsnb-06>
	<20120608152550.258d6a30.akpm@linux-foundation.org>
	<20120608222734.GT30000@ZenIV.linux.org.uk>
	<20120608153120.b722d7c3.akpm@linux-foundation.org>
	<20120608233127.GB18981@otc-wbsnb-06>
	<20120608163751.7a8ec2bc.akpm@linux-foundation.org>
	<CA+55aFw5k3daxeoZb9H1HGcOCWjPF+d7inSbf0QHmG-atp4reQ@mail.gmail.com>
	<20120608172842.9826b5cd.akpm@linux-foundation.org>
	<4FD2F5F4.1000106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>,
	linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, codalist-ySnCqBnJi5yMVn35/9/JlcWGCVk0P7UB@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>,
	v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>,
	fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Tao Ma <boyu.mt-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>,
	ecryptfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	logfs-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org, Boaz,
	"Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-btrfs-u79uwXL29Tb/PtFMR13I2A@public.gmane.org
To: Marco Stornelli <marco.stornelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <4FD2F5F4.1000106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 09 Jun 2012 09:06:28 +0200 Marco Stornelli <marco.stornelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Il 09/06/2012 02:28, Andrew Morton ha scritto:
> > On Fri, 8 Jun 2012 16:46:47 -0700 Linus Torvalds<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>  wrote:
> >
> >> Of course, if you just mean having a VFS wrapper that does
> >>
> >>      static void vfs_inode_kmem_cache_destroy(struct kmem_cache *cachep)
> >>      {
> >>          rcu_barrier();
> >>          kmem_cache_destroy(cachep);
> >>      }
> >>
> >> then we could do that. Not much better than what Kirill's patch did,
> >> but at least we could have that comment in just one single place.
> >
> > That's conceptually what I meant.  But it has the problem that new and
> > out-of-tree filesystems might forget to do it.  Which is why I suggest
> > adding a kmem_cache* argument to unregister_filesystem() for this.
> >
> > It's a bit awkward, and the fs can pass in NULL if it knows what it's
> > doing.  But it's reliable.
> > --
> 
> The call of rcu_barrier should be mandatory for the "unload fs module" 
> problem, right? If the fs is compiled statically maybe we could avoid 
> it, but (eventually) this kind of decision is per-fs, so this could be a 
> clue that the call of rcu_barrier maybe is inside each fs not in VFS.
> 

No, this is unrelated to module unloading and the problem affects
statically linked filesystems also.  The requirement is that all inodes
which are pending rcu freeing be flushed (and freed) before their cache
is destroyed in kmem_cache_destroy().

And...  it seems that I misread what's going on.  The individual
filesystems are doing the rcu freeing of their inodes, so it is
appropriate that they also call rcu_barrier() prior to running
kmem_cache_free().  Which is what Kirill's patch does.  oops.


------------------------------------------------------------------------------
Live Security Virtual Conference
Exclusive live event will cover all the ways today's security and 
threat landscape has changed and how IT managers can respond. Discussions 
will include endpoint security, mobile security and the latest in malware 
threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
