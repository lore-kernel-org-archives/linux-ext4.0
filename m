From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC, PATCH, RESEND] fs: push rcu_barrier() from
 deactivate_locked_super() to filesystems
Date: Fri, 8 Jun 2012 23:27:34 +0100
Message-ID: <20120608222734.GT30000@ZenIV.linux.org.uk>
References: <1339191663-17693-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120608150253.e42464a6.akpm@linux-foundation.org>
 <20120608221446.GA18250@otc-wbsnb-06>
 <20120608152550.258d6a30.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
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
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120608152550.258d6a30.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 08, 2012 at 03:25:50PM -0700, Andrew Morton wrote:

> A neater implementation might be to add a kmem_cache* argument to
> unregister_filesystem().  If that is non-NULL, unregister_filesystem()
> does the rcu_barrier() and destroys the cache.  That way we get to
> delete (rather than add) a bunch of code from all filesystems and new
> and out-of-tree filesystems cannot forget to perform the rcu_barrier().

There's often enough more than one cache, so that one is no-go.
