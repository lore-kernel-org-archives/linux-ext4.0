From: Josef Bacik <josef@redhat.com>
Subject: Hole Punching V2
Date: Mon, 15 Nov 2010 12:05:17 -0500
Message-ID: <1289840723-3056-1-git-send-email-josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
	cluster-dev
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is version 2 of the hole punching series I posted last week.  The following
things have changed

-Hole punching doesn't change file size
-Fixed the mode checks in ext4/btrfs/gfs2 so they do what they are supposed to

I posted updates to xfstests and xfsprogs in order to test this new interface,
and ran the test on xfs to make sure hole punching worked properly for xfs and I
tested it on btrfs to make sure it failed properly.  This series also adds
support for doing hole punching to ocfs2, but I did not test this part of it,
albiet it's an obvious fix so it should work fine.  Thanks,

Josef
