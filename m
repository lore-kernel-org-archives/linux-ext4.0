From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v5.2 00/14] crc32c: Add faster algorithm and self-test
	code
Date: Thu, 1 Dec 2011 12:31:22 -0800
Message-ID: <20111201203122.GC23175@tux1.beaverton.ibm.com>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201202053.GG1495@noexit.corp.google.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111201202053.GG1495@noexit.corp.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 01, 2011 at 12:20:53PM -0800, Joel Becker wrote:
> On Thu, Dec 01, 2011 at 12:13:41PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This patchset (re)uses Bob Pearson's crc32 slice-by-8 code to stamp out a
> > software crc32c implementation.  It removes the crc32c implementation in
> > crypto/ in favor of using the stamped-out one in lib/.  There is also a change
> > to Kconfig so that the kernel builder can pick an implementation best suited
> > for the hardware.
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
> 	I thought they usually used the SSE instruction for crc32 or
> equivalent.

They seem to call crc32c(), which is in crypto/crc32c.  If you're interested in
hardware accelerated crc32c on Intel, it is still the case that the wrapper for
that can be loaded via crc32c-intel.

--D
> 
> Joel
> 
> -- 
> 
> "I almost ran over an angel
>  He had a nice big fat cigar.
>  'In a sense,' he said, 'You're alone here
>  So if you jump, you'd best jump far.'"
> 
> 			http://www.jlbec.org/
> 			jlbec@evilplan.org
> 
