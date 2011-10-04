From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v5 0/4] crc32c: Add faster algorithm and self-test code
Date: Tue, 04 Oct 2011 16:53:57 -0700
Message-ID: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

This patchset (re)uses Bob Pearson's crc32 slice-by-8 code to stamp out a
software crc32c implementation.  It requires that all ten of his patches (at
least the ones dated 31 Aug 2011) be applied.  It removes the crc32c
implementation in crypto/ in favor of using the stamped-out one in lib/.  There
is also a change to Kconfig so that the kernel builder can pick an
implementation best suited for the hardware.

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

--D
