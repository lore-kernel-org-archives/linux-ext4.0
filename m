From: scjody@sun.com
Subject: [patch 0/5] Journal guided resync and support
Date: Thu, 19 Nov 2009 16:22:41 -0500
Message-ID: <20091119212241.283629302@sun.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35456 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZKSVXt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2009 16:23:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an updated implementation of journal guided resync, intended to be
suitable for production systems.  This feature addresses the problem with RAID
arrays that take too long to resync - similar to the existing MD write-intent
bitmap feature, we resync only the stripes that were undergoing writes at the
time of the crash.  Unlike write-intent bitmaps, our testing shows very little
performance degredation as a result of the feature - around 3-5% vs around 30%
for bitmaps.

This feature is based on work described in this paper:
http://www.usenix.org/events/fast05/tech/denehy.html

As a summary, we introduce a new data write mode known as declared mode.  This
is based on ordered mode except that a list of blocks to be written during the
current transaction is added to the journal before the blocks themselves are
written to the disk.  Then, if the system crashes, we can resync only those
blocks during journal replay and skip the rest of the resync of the RAID array.

The changes consist of patches to ext3, jbd, MD, and the raid456 personality.
These patches are currently against the RHEL 5 kernel 2.6.18-128.7.1.  Porting
to ext4/jbd2 and a more modern kernel is a TODO item.

Changes since the previous set of patches: I have addressed all review comments
received.  Noteable is a design change based on Neil Brown's suggestions: the
filesystem now sets a buffer flag (fs_raidsync) to inform MD that the
filesystem is taking responsibility for resyncing parity on this stripe in
the event of a system crash.  For RAID 4/5/6, setting this flag causes the
write intent bitmap NOT to be updated for the write in question.  There is
also a buffer flag (syncraid) used by jbd to resync parity.  Together these
eliminate most of the need for ioctls, though one is still needed for e2fsck.

Unfortunately, we have determined that these patches are NOT useful to Lustre.
Therefore I will not be doing any more work on them.  I am sending them now in
case they are useful as a starting point for someone else's work.

Cheers,
Jody
