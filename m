From: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Subject: Re: [PATCH 00/18] Consolidate Posix ACL implementation
Date: Thu, 5 Dec 2013 18:57:14 +0100 (CET)
Message-ID: <279325185.39210.1386266234086.JavaMail.zimbra@linbit.com>
References: <20131201115903.910559036@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>,
	reiserfs-devel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
	linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk,
	jfs-discussion@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Joel Becker <jlbec@evilplan.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20131201115903.910559036@bombadil.infradead.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

Christoph,

nice work, and a pretty diffstat.

I see that get_acl and set_acl are being defined in some but not all symlink inode operations (for example, btrfs them while ext4 does not), and that posix_acl_xattr_set() doesn't check if set_acl is defined.  Symlinks cannot have ACLs, so set_acl should either never be defined for symlinks (and a NULL check is then needed in posix_acl_xattr_set()), or it is defined in all inode operations, and S_ISNLNK() check is needed in posix_acl_xattr_set().  That latter check should probably be added in any case to be on the safe side.

  Test case:

  setfattr -h -n system.posix_acl_access \
           -v 0sAgAAAAEABgD/////AgAGABMEAAAEAAYA/////xAABgD/////IAAEAP////8= \
           symlink

Patch 6 also declares posix_acl_prepare() but this function is never introduced; this must be a leftover from a previous version.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
