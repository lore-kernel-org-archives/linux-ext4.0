From: Gary Hawco <ghawco@cox.net>
Subject: Re: Segmentation Faults with both 062608 snapshots
Date: Thu, 26 Jun 2008 22:12:27
Message-ID: <3.0.6.32.20080626221227.0242af78@pop.west.cox.net>
References: <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net> <48631792.3040202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao102.cox.net ([68.230.241.44]:58242 "EHLO
	fed1rmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYF0FM3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2008 01:12:29 -0400
In-Reply-To: <48631792.3040202@redhat.com>
References: <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
 <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

More on my segmentation problems. Just looking at the end of each kernel
message, they always end with:
EIP [XXXXX]  jbd2_journal_data_metadata-XXX

This occurs when I try to copy data from my main partition to a backup
partition or make a tarball.

Both partitions are setup with flex_bg,meta_bg,uninit_bg with ordered data
mode using noatime,nodiratime,journal_async_commit mount parameters.

Again, the snapshot from 062508/0019hrs GMT --
ext4-patch-queue-b5db22ef52ed53d8e3fa978a5a29e1609c9333aa.tar.gz
works fine patching a clean linux-2.6.26-rc6 source and exhibits no
problems whatsoever.

Starting with the next snapshot (062608/0042hrs GMT) is where my segfaults
start. This continues using the newest snapshot from 062608/2251hrs GMT.

I have patched the source from the individual snapshots mentioned as well
as just pulling and updating my ext4-patch-queue folder with the same
results. If I roll the kernel back to the 062508/0019 snapshot, the
problems vanish.

No errors noted during e2fsck -fvy on either partition.

This is driving me crazy!

Gary

