From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/11 RFC] quota: Unify VFS and XFS quota interfaces
Date: Tue, 11 Nov 2014 22:04:14 +0100
Message-ID: <1415739865-2438-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  this is a first (still partial) attempt to unify VFS and XFS quota interfaces
so that XFS quotactls work for filesystems with VFS quotas and vice versa.
This is useful so that userspace doesn't have to care that much about which
filesystem it is using at least when using basic quota functionality. In
particular we should be able to reuse project quota tests in xfstests for
ext4.

In this patch set I unify quotaon / quotaoff handling (Q_QUOTAON, Q_QUOTAOFF,
Q_XQUOTAON, Q_XQUOTAOFF calls) and fix some bugs in the Q_XGETQUOTA,
Q_XSETQLIM, Q_GETQUOTA, Q_SETQUOTA calls done by Christoph some time ago.  I
have actually verified that xfs_quota is able to work with ext4 filesystem
(after tweaking it to not check fs type) when these patches are applied.

What is still missing is unification of Q_XGETQSTATV, Q_GETINFO, Q_SETINFO.

Comments are welcome.

								Honza
