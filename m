From: scjody@sun.com
Subject: [patch 0/4] Journal guided resync and support
Date: Thu, 01 Oct 2009 18:39:29 -0400
Message-ID: <20091001223929.120106893@sun.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753841AbZJAWkO@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
These patches are currently against the RHEL 5 kernel 2.6.18-128.1.6.  Porting
to ext4/jbd2 and a more modern kernel is a TODO item.

Cheers,
Jody
