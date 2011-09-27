From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v2 0/3] crc32c: Add faster algorithm and self-test code
Date: Tue, 27 Sep 2011 15:12:39 -0700
Message-ID: <20110927221239.21653.17489.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Bob Pearson <rpearson@systemfabricworks.com>,
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

This patchset replaces the current crc32c software implementation, which uses a
slow per-byte lookup table algorithm, with a faster implementation that uses an
adaptation of the slice-by-8 algorithm that Bob Pearson has been pushing for
crc32.

The motivation for this patchset is that I am working on adding full metadata
checksumming to ext4[1].  As far as performance impact of adding checksumming
goes, I see nearly no change with a standard mail server ffsb simulation.  On a
test that involves only file creation and deletion and extent tree writes, I
see a drop of about 50 pcercent with the current kernel crc32c implementation;
this improves to a drop of about 20 percent with the enclosed crc32c code.

When metadata is usually a small fraction of total IO, this new implementation
doesn't help much because metadata is usually a small fraction of total IO.
However, when we are doing IO that is almost all metadata (such as rm -rf'ing a
tree), then this patch speeds up the operation substantially.

Please have a look at the patches, and please feel free to suggest any changes.
I will be at LPC next week if anyone wishes to discuss, debate, or protest.

Incidentally, given that iscsi, sctp, and btrfs also use crc32c, this patchset
should improve their speed as well.  I have not yet quantified that, however.

v2: Use the crypto test manager code to check crc32c operation.

--D

[1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
