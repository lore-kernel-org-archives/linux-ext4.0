From: Josef Bacik <josef@redhat.com>
Subject: Hole Punching V3
Date: Wed, 17 Nov 2010 20:46:14 -0500
Message-ID: <1290044780-2902-1-git-send-email-josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
	cluster-dev
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is version 3 of the hole punching series I've been posting.  Not much has
changed, the history is below

V2->V3
-FALLOC_FL_PUNCH_HOLE must also have FALLOC_FL_KEEP_SIZE in order to work
-formatting fixes

V1->V2
-Hole punching doesn't change file size
-Fixed the mode checks in ext4/btrfs/gfs2 so they do what they are supposed to

I've updated my local copies of the xfsprogs patches I have to test this to use
KEEP_SIZE and PUNCH_HOLE together, I'll post them after it looks like these
patches are good to go, including the manpage update.  The xfstest I wrote ran
fine both on xfs and btrfs (failing on btrfs obviously).  Thanks,

Josef
