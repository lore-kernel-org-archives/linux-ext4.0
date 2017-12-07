From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0/4] e2scrub: online fsck for ext4
Date: Thu, 07 Dec 2017 10:48:23 -0800
Message-ID: <151267250365.1350.7799938074608034424.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54451 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdLGTBG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Dec 2017 14:01:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This patch series develops more fully the e2croncheck contrib script.
We start with a e2scrub command that, given an ext4 filesystem on a LVM
volume, creates a snapshot if there's more than 256M free in the LVM
group, runs e2fsck on the snapshot, and deletes the snapshot.  If the
fsck ran cleanly, the fs last-check timestamp is updated and fstrim is
run.  If corruption is found we mark the fs as needing a fsck and advise
a reboot.  A udev rule file is used to prevent the creation of /dev/disk
symlinks to the snapshot.

Next we create an e2scrub_all command that finds all ext4 filesystems
living in LVM volumes and iteratively calls e2scrub on each of them.

The third patch creates a weekly cron job for automatic invocation as
well as systemd service files so that we can (try to) sandbox the scrub
process and run it with idle priority to reduce latency spikes in the
main filesystem.

The fourth patch teaches the build system to build with LTO enabled, and
enables it for the debian package.  This reduces the size of the static
e2fsck binary by 30%, though the static libraries are now significantly
larger because we ship the LTO information.

Missing from this is a boot-time service to remove stale fsck snapshots.

--D
