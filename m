From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/11 v1] Fix inheritance of SGID in presence
	of default ACLs
Date: Thu, 22 Jun 2017 15:31:04 +0200
Message-ID: <20170622133115.16968-1-jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
	Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>,
	linux-btrfs@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-xfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	pvfs2-developers@beowulf-underground.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	Mike Marshall <hubcap@omnibond.com>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <cluster-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Hello,

this patch set fixes a problem introduced by commit 073931017b49 "posix_acl:
Clear SGID bit when setting file permissions". The problem is that when new
directory 'DIR1' is created in a directory 'DIR0' with SGID bit set, DIR1 is
expected to have SGID bit set (and owning group equal to the owning group of
'DIR0'). However when 'DIR0' also has some default ACLs that 'DIR1' inherits,
setting these ACLs will result in SGID bit on 'DIR1' to get cleared if user is
not member of the owning group.

The problem is fixed by moving posix_acl_update_mode() so that it does not
get called when default ACLs are inherited.

I have created new generic/441 test for this and verified that generic/314,
generic/375, and generic/441 pass for ext2, ext4, btrfs, xfs, ocfs2, reiserfs.

All patches in this series are completely independent so fs maintainers please
pick them up as soon as they get reviewed. I'm leaving for three weeks of
vacation at the end of the week so I won't be able to push this further for
some time.

								Honza
