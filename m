From: David Hayes <davemellow@gmail.com>
Subject: restoring ext3 filesystem overwritten by ext4
Date: Sat, 21 Jul 2012 20:49:07 +1200
Message-ID: <CAGFSy5kJFtBH5ogrppKNXht24bPc+9qQhvupqEyhkShxdpHNaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58483 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2GUItI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jul 2012 04:49:08 -0400
Received: by wgbdr13 with SMTP id dr13so4335225wgb.1
        for <linux-ext4@vger.kernel.org>; Sat, 21 Jul 2012 01:49:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a general question about whether it should be possible to
effectively undo a mkfs.ext4 on a partition which previously held an
ext3 filesystem. I'm just a user, not a developer, so I'm not familiar
with the details of where backup superblocks get written etc. I had no
luck finding any old filesystem information with testdisk, so I'm
wondering whether ext4 might overwrite all the superblocks by
coincidence of choosing the same blocks in the partition to write them
as mkfs.ext3 did, or something.

If the answer to the above is "yes" I'll respond with more specific
details if required.

Thanks,
David.
