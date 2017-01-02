From: Roman Pen <roman.penyaev@profitbricks.com>
Subject: [PATCH 0/3] ext4: fallocate insert/collapse range fixes
Date: Mon,  2 Jan 2017 13:54:47 +0100
Message-ID: <20170102125450.22807-1-roman.penyaev@profitbricks.com>
Cc: Roman Pen <roman.penyaev@profitbricks.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all.

For couple of days I've played with inserting and collapsing range using
fallocate and have found two nasty bugs:

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

3.  Just a minor optimization: linear search of a extent inside a block is
replaced by a binsearch.  This is the third patch.

Roman Pen (3):
  ext4: Include forgotten start block on fallocate insert range
  ext4: Do not populate extents tree with outdated offsets while
    shifting extents
  ext4: Find desired extent in ext4_ext_shift_extents() using binsearch

 fs/ext4/extents.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
-- 
2.10.2
