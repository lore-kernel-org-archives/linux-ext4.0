From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [PATCH v4] crc32c: Implement CRC32c with slicing-by-8 algorithm
Date: Sat, 1 Oct 2011 16:02:10 +0200
Message-ID: <OF54094699.6F5CF2B6-ONC125791C.004C901C-C125791C.004D1A61@transmode.se>
References: <20110930192956.4176.29905.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Mingming Cao <cmm@us.ibm.com>,
	David Miller <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	Theodore Tso <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20110930192956.4176.29905.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


"Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/09/30 21:29:56:
>
> The existing CRC32c implementation uses Sarwate's algorithm to calculate the
> code one byte at a time.  Using a slicing-by-8 algorithm adapted from Bob
> Pearson, we can process buffers 8 bytes at a time, for a substantial increase
> in performance.
>
> The motivation for this patchset is that I am working on adding full metadata
> checksumming to ext4 and jbd2.  As far as performance impact of adding
> checksumming goes, I see nearly no change with a standard mail server ffsb
> simulation.  On a test that involves only metadata operations (file creation
> and deletion, and fallocate/truncate), I see a drop of about 50 pcercent with
> the current kernel crc32c implementation; this improves to a drop of about 20
> percent with the enclosed crc32c code.
>
> When metadata is usually a small fraction of total IO, this new implementation
> doesn't help much because metadata is usually a small fraction of total IO.
> However, when we are doing IO that is almost all metadata (such as rm -rf'ing a
> tree), then this patch speeds up the operation substantially.
>
> Given that iscsi, sctp, and btrfs also use crc32c, this patchset should improve
> their speed as well.  I have some preliminary results[1] that show the
> difference in various crc algorithms that I've come across: the "crc32c-by8-le"
> column is the new algorithm in the patch; the "crc32c" column is the current
> crc32c kernel implementation; and the "crc32-kern-le" column is the current
> crc32 kernel implementation, which is similar to the results one gets for
> CONFIG_CRC32C_SLICEBY4=y.  As you can see, the new implementation runs at
> nearly 4x the speed of the current implementation; even the slimmer slice-by-4
> implementation is generally 2-3x faster.
>
> However, the implementation allows the kernel builder to select from a variety
> of space-speed tradeoffs, should my results not hold true on a particular
> class of system.
>
> v2: Use the crypto testmgr api for self-test.
> v3: Get rid of the -be version, which had no users.
> v4: Allow kernel builder a choice of speed vs. space optimization.
>
> [1]http://djwong.org/docs/ext4_metadata_checksums.html
> (cached copy of the ext4 wiki)
>
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

This is based on an old version of Bobs slice by 8 that has lots duplication and
hard to maintain.

Start from Bobs latest patches and add crc32c to lib/crc32.c

Also, for crc32c I think you only need slice by 4 and slice by 8

 Jocke
