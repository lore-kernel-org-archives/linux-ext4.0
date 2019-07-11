Return-Path: <SRS0=NrDr=VI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E514EC74A35
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Jul 2019 14:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEBC12166E
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Jul 2019 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562854710;
	bh=zxkWNgWAcdgDEs1e0ke3VX57cNWOkZWU0UUe/G7zWoU=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=gBqUeaMmT9LII+2ihFtiS/ehgKCO0ayhSyi0dS+npiXD+225Lx8O3CfuzjcOk7OOF
	 gf7yiLHp9S8qhF2ZPoEu7Pj/pMW86N/LWixnHbk1J0oLTE4uPqyLh8l7fMDQv6f1B5
	 Ikw392hYiMYGyS9rokO1f9XdjoZeSuQqkZQLz7hw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbfGKOS0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Jul 2019 10:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbfGKOS0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Jul 2019 10:18:26 -0400
Received: from localhost (c-67-169-218-210.hsd1.or.comcast.net [67.169.218.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1F7321537;
        Thu, 11 Jul 2019 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562854705;
        bh=zxkWNgWAcdgDEs1e0ke3VX57cNWOkZWU0UUe/G7zWoU=;
        h=Date:From:To:Cc:Subject:From;
        b=aBUUZFgsgg5wBsaDq5QRISmheVCa1Jl2f77SUULojLCZuYrYYoexyBVnGYtKo0D7O
         WQwldng+7Ilw7o2enbcVZUz+LvsvppoBCQecvYxWonrb0tVdTRbB9B1PoJtFiMdv1D
         R2L6mqtUtnEST5hxxcA8UvqM/m0Zpgb2zPRxIBv8=
Date:   Thu, 11 Jul 2019 07:18:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] vfs: standardize parameter checking for
 SETFLAGS/FSSETXATTR ioctls
Message-ID: <20190711141825.GV1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Linus,

Here's a patch series that sets up common parameter checking functions
for the FS_IOC_SETFLAGS and FS_IOC_FSSETXATTR ioctl implementations.
The goal here is to reduce the amount of behaviorial variance between
the filesystems where those ioctls originated (ext2 and XFS,
respectively) and everybody else.

The branch merges cleanly against this morning's HEAD and survived an
overnight run of xfstests.  The merge was completely straightforward, so
please let me know if you run into anything weird.

--D

The following changes since commit d1fdb6d8f6a4109a4263176c84b899076a5f8008:

  Linux 5.2-rc4 (2019-06-08 20:24:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-fix-ioctl-checking-3

for you to fetch changes up to dbc77f31e58b2902a5e7643761c04bf69f57a32a:

  vfs: only allow FSSETXATTR to set DAX flag on files and dirs (2019-07-01 08:25:36 -0700)

----------------------------------------------------------------
New for 5.3:
- Standardize parameter checking for the SETFLAGS and FSSETXATTR ioctls
  (which were the file attribute setters for ext4 and xfs and have now
  been hoisted to the vfs)
- Only allow the DAX flag to be set on files and directories.

----------------------------------------------------------------
Darrick J. Wong (5):
      vfs: create a generic checking and prep function for FS_IOC_SETFLAGS
      vfs: create a generic checking function for FS_IOC_FSSETXATTR
      vfs: teach vfs_ioc_fssetxattr_check to check project id info
      vfs: teach vfs_ioc_fssetxattr_check to check extent size hints
      vfs: only allow FSSETXATTR to set DAX flag on files and dirs

 fs/btrfs/ioctl.c    |  30 ++++------
 fs/efivarfs/file.c  |  26 ++++++---
 fs/ext2/ioctl.c     |  16 ++----
 fs/ext4/ioctl.c     |  51 +++++------------
 fs/gfs2/file.c      |  42 +++++++++-----
 fs/hfsplus/ioctl.c  |  21 ++++---
 fs/inode.c          |  86 +++++++++++++++++++++++++++++
 fs/jfs/ioctl.c      |  22 +++-----
 fs/nilfs2/ioctl.c   |   9 +--
 fs/ocfs2/ioctl.c    |  13 +----
 fs/orangefs/file.c  |  37 ++++++++++---
 fs/reiserfs/ioctl.c |  10 ++--
 fs/ubifs/ioctl.c    |  13 +----
 fs/xfs/xfs_ioctl.c  | 154 +++++++++++++++++++++++-----------------------------
 include/linux/fs.h  |  12 ++++
 15 files changed, 300 insertions(+), 242 deletions(-)
