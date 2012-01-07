From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v5.3 00/14] crc32c: Add faster algorithm and self-test code
Date: Fri, 06 Jan 2012 21:50:42 -0800
Message-ID: <20120107055042.31315.63119.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

This patchset (re)uses Bob Pearson's crc32 slice-by-8 code to stamp out a
software crc32c implementation.  It removes the crc32c implementation in
crypto/ in favor of using the stamped-out one in lib/.  There is also a change
to Kconfig so that the kernel builder can pick an implementation best suited
for the hardware.

The motivation for this patchset is that I am working on adding full metadata
checksumming to ext4.  As far as performance impact of adding checksumming
goes, I see nearly no change with a standard mail server ffsb simulation.  On a
test that involves only file creation and deletion and extent tree writes, I
see a drop of about 50 pcercent with the current kernel crc32c implementation;
this improves to a drop of about 20 percent with the enclosed crc32c code.

When metadata is usually a small fraction of total IO, this new implementation
doesn't help much because metadata is usually a small fraction of total IO.
However, when we are doing IO that is almost all metadata (such as rm -rf'ing a
tree), then this patch speeds up the operation substantially.

Incidentally, given that iscsi, sctp, and btrfs also use crc32c, this patchset
should improve their speed as well.  I have not yet quantified that, however.
This latest submission combines Bob's patches from late August 2011 with mine
so that they can be one coherent patch set.  Please excuse my inability to
combine some of the patches; I've been advised to leave Bob's patches alone and
build atop them instead. :/

Since the last posting, I've also collected some crc32c test results on a bunch
of different x86/powerpc/sparc platforms.  The results can be viewed here:
http://goo.gl/sgt3i ; the "crc32-kern-le" and "crc32c" columns describe the
performance of the kernel's current crc32 and crc32c software implementations.
The "crc32c-by8-le" column shows crc32c performance with this patchset applied.
I expect crc32 performance to be roughly the same.

The two _boost columns at the right side of the spreadsheet shows how much
faster the new implementation is over the old one.  As you can see, crc32 rises
substantially, and crc32c experiences a huge increase.

Since this patch has been out for review for several weeks now without
objections, can this go into 3.3, please?

v2: Use the crypto testmgr api for self-test.
v3: Get rid of the -be version, which had no users.
v4: Allow kernel builder a choice of speed vs. space optimization.
v5: Reuse lib/crc32 for crc32c as well, and make crypto/crc32c use lib/crc32.c.
v5.1: Include Bob Pearson's patches in submission request.
v5.2: Fix changelogs for Bob's patches per akpm request.
v5.3: Fix from header bug in patch mail generation scripts.

--D
