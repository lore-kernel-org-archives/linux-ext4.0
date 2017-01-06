From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH v2 0/2] ext4: fallocate insert/collapse range fixes
Date: Fri,  6 Jan 2017 21:25:59 +0100
Message-ID: <20170106202601.32722-1-roman.penyaev@profitbricks.com>
Cc: Roman Pen <roman.penyaev@profitbricks.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38440 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936671AbdAFU0Q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jan 2017 15:26:16 -0500
Received: by mail-wm0-f41.google.com with SMTP id k184so45505229wme.1
        for <linux-ext4@vger.kernel.org>; Fri, 06 Jan 2017 12:26:15 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This is the second version of a patchset which targets two nasty bugs in
a logic responsible for shifting extents.  The difference between series
is that in this set the third patch, where I incorrectly tried to optimize
linear search, is skipped.

I ran the 'kvm-xfstests.sh -c 4k -g auto' against b25ead75e7b6 4.10-rc2
with and without my changes.  No regressions were found.

1k configuration was run against latest Linus's mainline.  Also no
regressions were found.

Two patches in a set target two problems, which can be easily reproduced
by the following new xfstest:

  http://www.spinics.net/lists/linux-ext4/msg54965.html

1.  On right shift (insert range) start block is not included in the range
and hole appears at the wrong offset.  The bug can be easily reproduced by
the following test:

    ptr = malloc(4096);
    assert(ptr);

    fd = open("./ext4.file", O_CREAT | O_TRUNC | O_RDWR, 0600);
    assert(fd >= 0);

    rc = fallocate(fd, 0, 0, 8192);
    assert(rc == 0);
    for (i = 0; i < 2048; i++)
            *((unsigned short *)ptr + i) = 0xbeef;
    rc = pwrite(fd, ptr, 4096, 0);
    assert(rc == 4096);
    rc = pwrite(fd, ptr, 4096, 4096);
    assert(rc == 4096);

    for (block = 2; block < 1000; block++) {
            rc = fallocate(fd, FALLOC_FL_INSERT_RANGE, 4096, 4096);
            assert(rc == 0);

            for (i = 0; i < 2048; i++)
                    *((unsigned short *)ptr + i) = block;

            rc = pwrite(fd, ptr, 4096, 4096);
            assert(rc == 4096);
    }

After the test no zero blocks should appear (test always does pwrite() after
fallocate), but zero blocks do exist:

  $ hexdump ./ext4.file | grep '0000 0000'

This bug is targeted by the first patch in the set.

2.  Inside ext4_ext_shift_extents() function ext4_find_extent() is called
without EXT4_EX_NOCACHE flag, which should prevent cache population.  This
leads to outdated offsets in the extents tree and wrong data blocks, which
can be observed doing read().  That is also quite well reproduced by the
test above.

This is fixed by the second patch.

Roman Pen (2):
  ext4: Include forgotten start block on fallocate insert range
  ext4: Do not populate extents tree with outdated offsets while
    shifting extents

 fs/ext4/extents.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
-- 
2.10.2

