From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC, PATCH, RESEND] fs: push rcu_barrier() from
 deactivate_locked_super() to filesystems
Date: Fri, 8 Jun 2012 23:23:37 +0100
Message-ID: <20120608222337.GR30000@ZenIV.linux.org.uk>
References: <1339191663-17693-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120608150253.e42464a6.akpm@linux-foundation.org>
 <20120608221446.GA18250@otc-wbsnb-06>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Tao Ma <boyu.mt@taobao.com>, Nick Piggin <npiggin@kernel.dk>,
	"Dmitry V. Levin" <ldv@altlinux.org>,
	v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	codalist@TELEMANN.coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
	osd-dev@open-osd.org, linux-ext4@vger.kernel.org,
	fuse-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org,
	jfs-discussion@lists.sourceforge.net, logfs@logfs.org,
	linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120608221446.GA18250@otc-wbsnb-06>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 09, 2012 at 01:14:46AM +0300, Kirill A. Shutemov wrote:
> > The implementation would be less unpleasant if we could do the
> > rcu_barrier() in kmem_cache_destroy().  I can't see a way of doing that
> > without adding a dedicated slab flag, which would require editing all
> > the filesystems anyway.
> 
> I think rcu_barrier() for all kmem_cache_destroy() would be too expensive.

You've got to be kidding.  Please, show us the codepath that would be hot
enough to make that too expensive and would contain kmem_cache_destroy().
Note that module unload is *not* a hot path - not on any even remotely sane
use.
