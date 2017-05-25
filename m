From: Marc Thomas <marc@dragonfly.plus.com>
Subject: Re: [PATCH] e2fsck: fix sparse bmap to extent conversion
Date: Thu, 25 May 2017 14:11:52 +0100
Message-ID: <e8704df9-dac3-d7c8-2907-b116d9a3f2e6@dragonfly.plus.com>
References: <20170523190019.GF4510@birch.djwong.org>
 <982fc176-2a8d-1318-8eec-2524c6af1e00@dragonfly.plus.com>
 <20170525022135.tbzsiyd3cbvrdlto@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avasout01.plus.net ([84.93.230.227]:54924 "EHLO
        avasout01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765794AbdEYNL4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 May 2017 09:11:56 -0400
In-Reply-To: <20170525022135.tbzsiyd3cbvrdlto@thunk.org>
Content-Language: en-GB
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thank you both for the rapid turn-around with this patch.
I can confirm it solves the original problem with the in-place ext3 to
ext4 conversion I'm doing.

As regards the f_detect_junk test, it seems a change in "debugfs" is
emitting an extra message "Checksum errors in superblock!  Retrying..."
which is not present in the "expect" output.
It appears this was introduced in commit
https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/commit/?id=bf615bb0ccadeb1579463f94a2a4752e7ec53f57

Perhaps debugfs could print that message to stderr so it's not picked up?

I'm testing with the git master branch, but my git skills are weak so I
could well be doing something wrong!

Kind Regards,
Marc
