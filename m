From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [PATCH v5 0/4] crc32c: Add faster algorithm and self-test code
Date: Fri, 7 Oct 2011 09:38:01 +0200
Message-ID: <OF47136962.36AF976D-ONC1257922.0029A6FB-C1257922.0029EF1C@transmode.se>
References: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com> <20111006202042.GD12447@tux1.beaverton.ibm.com>
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
To: djwong@us.ibm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20111006202042.GD12447@tux1.beaverton.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/10/06 22:20:42:
> Subject: Re: [PATCH v5 0/4] crc32c: Add faster algorithm and self-test code
>
> On Tue, Oct 04, 2011 at 04:53:57PM -0700, Darrick J. Wong wrote:
> > Hi all,
> >
> > This patchset (re)uses Bob Pearson's crc32 slice-by-8 code to stamp out a
> > software crc32c implementation.  It requires that all ten of his patches (at
> > least the ones dated 31 Aug 2011) be applied.  It removes the crc32c
> > implementation in crypto/ in favor of using the stamped-out one in lib/.  There
> > is also a change to Kconfig so that the kernel builder can pick an
> > implementation best suited for the hardware.
> >
> > The motivation for this patchset is that I am working on adding full metadata
> > checksumming to ext4.  As far as performance impact of adding checksumming
> > goes, I see nearly no change with a standard mail server ffsb simulation.  On a
> > test that involves only file creation and deletion and extent tree writes, I
> > see a drop of about 50 pcercent with the current kernel crc32c implementation;
> > this improves to a drop of about 20 percent with the enclosed crc32c code.
> >
> > When metadata is usually a small fraction of total IO, this new implementation
> > doesn't help much because metadata is usually a small fraction of total IO.
> > However, when we are doing IO that is almost all metadata (such as rm -rf'ing a
> > tree), then this patch speeds up the operation substantially.
> >
> > Incidentally, given that iscsi, sctp, and btrfs also use crc32c, this patchset
> > should improve their speed as well.  I have not yet quantified that, however.
>
> As for Mr. Tjernlund's unresolved questions regarding the v4 patch, I have
> tested this new code on x64/x32/ppc32/ppc64 and it seems to work fine, both
> with the crc32c selftest and also on a practical level with ext4 metadata
> checksumming enabled.  Updating to Bob's newest calculation code brings about a
> 10-15% speedup on the ppc64 box.  I also see that slice-by-8 is about 20%
> faster than slice-by-4 on my ppc32 box.
>
> I did _not_ see any failures on ppc32 when running an extended ext4+checksum
> test suite.

Hi Darrick, I finally had some time to look this series over and I like
this much better. Thank you for your patience with me :)

Acked-By: Joakim Tjernlund <joakim.tjernlund@transmode.se>

 Jocke
