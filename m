From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC, PATCH,
 RESEND] fs: push rcu_barrier() from deactivate_locked_super() to
 filesystems
Date: Fri, 8 Jun 2012 16:37:51 -0700
Message-ID: <20120608163751.7a8ec2bc.akpm@linux-foundation.org>
References: <1339191663-17693-1-git-send-email-kirill.shutemov@linux.intel.com>
	<20120608150253.e42464a6.akpm@linux-foundation.org>
	<20120608221446.GA18250@otc-wbsnb-06>
	<20120608152550.258d6a30.akpm@linux-foundation.org>
	<20120608222734.GT30000@ZenIV.linux.org.uk>
	<20120608153120.b722d7c3.akpm@linux-foundation.org>
	<20120608233127.GB18981@otc-wbsnb-06>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, "Dmitry V. Levin" <ldv@altlinux.org>,
	linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	Nick Piggin <npiggin@kernel.dk>,
	fuse-devel@lists.sourceforge.net, Ma <boyu.mt@taobao.com>,
	ecryptfs@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	osd-dev@open-osd.org, ceph-devel@vger.kernel.org,
	codalist@TELEMANN.coda.cs.cmu.edu, linux-nfs@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	logfs@logfs.org, Al Viro <viro@ZenIV.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, Tao,
	Linus Torvalds <torvalds@linux-foundation.org>, linux-btrfs@vger.kernel.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <20120608233127.GB18981@otc-wbsnb-06>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Sat, 9 Jun 2012 02:31:27 +0300
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> On Fri, Jun 08, 2012 at 03:31:20PM -0700, Andrew Morton wrote:
> > On Fri, 8 Jun 2012 23:27:34 +0100
> > Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > On Fri, Jun 08, 2012 at 03:25:50PM -0700, Andrew Morton wrote:
> > > 
> > > > A neater implementation might be to add a kmem_cache* argument to
> > > > unregister_filesystem().  If that is non-NULL, unregister_filesystem()
> > > > does the rcu_barrier() and destroys the cache.  That way we get to
> > > > delete (rather than add) a bunch of code from all filesystems and new
> > > > and out-of-tree filesystems cannot forget to perform the rcu_barrier().
> > > 
> > > There's often enough more than one cache, so that one is no-go.
> > 
> > kmem_cache** ;)
> > 
> > Which filesystems have multiple inode caches?
> 
> Multiple inode caches? No.
> Multiple caches with call_rcu() free? See btrfs or gfs2.

OK.  But for those non-inode caches, the rcu treatment is private to
the filesystem.  Hence it is appropriate that the filesystem call
rcu_barrier() for those caches.

But in the case of the inode caches, the rcu treatment is a vfs thing,
so it is the vfs which should perform the rcu_barrier().

This is a red herring - those non-inode caches have nothing to do with
the issue we're dicussing.


So how about open-coding the rcu_barrier() in btrfs and gfs2 for the
non-inode caches (which is the appropriate place), and hand the inode
cache over to the vfs for treatment (which is the appropriate place).

The downside is that btrfs and gfs2 will do an extra rcu_barrier() at
umount time.  Shrug.

If they really want to super-optimise that, they can skip the private
rcu_barrier() call and assume that the vfs will be doing it.  Not a
good idea, IMO.



------------------------------------------------------------------------------
Live Security Virtual Conference
Exclusive live event will cover all the ways today's security and 
threat landscape has changed and how IT managers can respond. Discussions 
will include endpoint security, mobile security and the latest in malware 
threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
