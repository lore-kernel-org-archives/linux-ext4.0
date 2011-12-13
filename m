From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [PATCH 14/14] crc32: Select an algorithm via kconfig
Date: Tue, 13 Dec 2011 09:27:10 +0100
Message-ID: <OF62576D22.A1ACD2B5-ONC1257965.002E3817-C1257965.002E6F16@transmode.se>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201201517.5876.39207.stgit@elm3c44.beaverton.ibm.com> <20111202002505.GB19842@gondor.apana.org.au> <20111203023646.GB16577@tux1.beaverton.ibm.com> <20111212225857.GM7137@tux1.beaverton.ibm.com> <02ea01ccb923$48193ff0$d84bbfd0$@systemfabricworks.com> <20111213063228.GN7137@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "'Andreas Dilger'" <adilger.kernel@dilger.ca>,
	"'Andrew Morton'" <akpm@linux-foundation.org>,
	"'Mingming Cao'" <cmm@us.ibm.com>,
	"'Herbert Xu'" <herbert@gondor.apana.org.au>,
	"'linux-crypto'" <linux-crypto@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	"'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
	"'linux-kernel'" <linux-kernel@vger.kernel.org>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	"'Theodore Tso'" <tytso@mit.edu>
To: djwong@us.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111213063228.GN7137@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/12/13 07:32:28:
>
> On Mon, Dec 12, 2011 at 05:10:45PM -0600, Bob Pearson wrote:
> > That choice was for Joakim who measured better performance on his 32 bit PPC
> > platform with "by 4".
>
> Ok.  On my 1.33GHz PowerBook I get ~255MB/s with slice by 4 and ~270MB/s with
> slice by 8.  I think it's a PPC 7447, and definitely 32-bit.  In any case, it
> reports having 32K of L1D cache.

I tested Bobs early version on my mpc8321(266MHz, embedded CPU) and it was just
half the speed compared with current crc32.

 Jocke
