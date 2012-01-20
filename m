From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/8] Fix filesystem freezing
Date: Fri, 20 Jan 2012 21:34:38 +0100
Message-ID: <1327091686-23177-1-git-send-email-jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


  Hello,

  This is the second iteration of my patches to improve filesystem freezing.
Filesystem freezing is currently racy and thus we can end up with dirty data
on frozen filesystem (see changelog of the first patch for detailed race
description and proposed fix). This patch series aims at fixing this.

The biggest changes since v1:
  * have two counters to provide safe state transitions for SB_FREEZE_WRITE
    and SB_FREEZE_TRANS states
  * use percpu counters instead of own percpu structure
  * added documentation fixes from the old fs freezing series
  * converted XFS to use SB_FREEZE_TRANS counter instead of its private
    m_active_trans counter

Now I'm sending this mostly as a heads up so that people see current state
because these patches are still racy. The problem is that when superblock is in
SB_FREEZE_WRITE state inodes can still be dirtied (e.g. through touch_atime,
directory operations or similar). These inodes then are not flushed and when
superblock passes to SB_FREEZE_TRANS state, flusher thread deadlocks on trying
to flush them.

To fix this, we will have to block also operations dirtying inodes already
in SB_FREEZE_WRITE state. I'm now looking into how to do this in the easiest
way.

								Honza
