From: Amir Goldstein <amir73il@gmail.com>
Subject: Clearing the way for ext4 snapshots
Date: Tue, 1 Mar 2011 20:31:19 +0200
Message-ID: <AANLkTimyDrhdqgSEmpwGP6R9iR5p4zwiaW9N-js-tnyN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50778 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1CASbU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 13:31:20 -0500
Received: by qyk7 with SMTP id 7so3547914qyk.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Mar 2011 10:31:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I pushed a few small patches today, all are pre-snapshot patches,
which I hope you can merge in coming merge window.

These 2, are the only snapshot patches outside fs/ext4:

[PATCH 1/2] jbd2: add the b_cow_tid field to journal_head struct 						
[PATCH 2/2] jbd2: add the h_cowing flag and debug counters to
jbd2_journal_handle struct

Merging them soon will allow early ext4 snapshots testers to build a standalone
module, without having to patch and build the kernel.

These 2, are no-brainer error handling.
Since they are not an integral part of the snapshot patches,
I rather merge them sooner and not clutter the snapshot patches
review with unrelated stuff.

[PATCH 1/2] ext4: handle errors in ext4_rename 						
[PATCH 2/2] ext4: handle errors in ext4_clear_blocks() 						

This one is also a no-brainer cleanup, which will be required by snapshots.

[PATCH] ext4: fix callers of ext4_handle_release_buffer() API 						

Thanks,
Amir.
