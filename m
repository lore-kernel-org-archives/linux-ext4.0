From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC] online scrub for ext4
Date: Fri, 21 Jul 2017 17:26:43 -0700
Message-ID: <20170722002643.GD4211@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49986 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdGVA0s (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jul 2017 20:26:48 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

On this week's conference call, we discussed polishing e2croncheck into
something resembling a workable package, and I mentioned that some time
ago I'd adapted the script into a more general utility.  I've cleaned up
the scripts somewhat, so we can use them as a basis for discussion.

The first mail contains the base script to create the lvm snapshot, fsck
the snapshot, remove the snapshot, and fstrim the original filesystem.
It also contains a udev script to discourage it from making symlinks in
/dev/disk.

The second mail contains a script to identify eligible lvs containing
ext4 filesystms and call the actual invoker script.

The third mail contains systemd units to manage invocation and
containment of the scripts.

Note that despite my earlier outline, I don't actually have a boot time
script that cleans out any leftover fsck snapshots, though it wouldn't
be difficult to write.

Note also the lack of distro installer/partitioner support -- your ext4
filesystems /must/ be managed by lvm, and you /must/ have at least 256M
free in each volume group.  There's no daemon to watch for snapshots
filling up in order to kill the fsck and snapshot.

--D
