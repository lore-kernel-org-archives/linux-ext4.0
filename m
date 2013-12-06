From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/18] Consolidate Posix ACL implementation
Date: Fri, 6 Dec 2013 11:46:37 -0800
Message-ID: <20131206194637.GA32122@infradead.org>
References: <20131201115903.910559036@bombadil.infradead.org>
 <279325185.39210.1386266234086.JavaMail.zimbra@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
	jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
	linux-nfs@vger.kernel.org
To: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <279325185.39210.1386266234086.JavaMail.zimbra@linbit.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 05, 2013 at 06:57:14PM +0100, Andreas Gruenbacher wrote:
> I see that get_acl and set_acl are being defined in some but not all symlink inode operations (for example, btrfs them while ext4 does not), and that posix_acl_xattr_set() doesn't check if set_acl is defined.  Symlinks cannot have ACLs, so set_acl should either never be defined for symlinks (and a NULL check is then needed in posix_acl_xattr_set()), or it is defined in all inode operations, and S_ISNLNK() check is needed in posix_acl_xattr_set().  That latter check should probably be added in any case to be on the safe side.

Yes, we should add the check.  We also in general should not have
set_acl/get_acl on links and I'll look over it.

> Patch 6 also declares posix_acl_prepare() but this function is never introduced; this must be a leftover from a previous version.

Indeed.

Thanks for the review!

