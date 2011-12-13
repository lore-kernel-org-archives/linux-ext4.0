From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 14/14] crc32: Select an algorithm via kconfig
Date: Tue, 13 Dec 2011 10:36:44 -0800
Message-ID: <20111213183644.GO7137@tux1.beaverton.ibm.com>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201201517.5876.39207.stgit@elm3c44.beaverton.ibm.com> <20111202002505.GB19842@gondor.apana.org.au> <20111203023646.GB16577@tux1.beaverton.ibm.com> <20111212225857.GM7137@tux1.beaverton.ibm.com> <02ea01ccb923$48193ff0$d84bbfd0$@systemfabricworks.com> <20111213063228.GN7137@tux1.beaverton.ibm.com> <OF62576D22.A1ACD2B5-ONC1257965.002E3817-C1257965.002E6F16@transmode.se>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF62576D22.A1ACD2B5-ONC1257965.002E3817-C1257965.002E6F16@transmode.se>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 13, 2011 at 09:27:10AM +0100, Joakim Tjernlund wrote:
> "Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/12/13 07:32:28:
> >
> > On Mon, Dec 12, 2011 at 05:10:45PM -0600, Bob Pearson wrote:
> > > That choice was for Joakim who measured better performance on his 32 bit PPC
> > > platform with "by 4".
> >
> > Ok.  On my 1.33GHz PowerBook I get ~255MB/s with slice by 4 and ~270MB/s with
> > slice by 8.  I think it's a PPC 7447, and definitely 32-bit.  In any case, it
> > reports having 32K of L1D cache.
> 
> I tested Bobs early version on my mpc8321(266MHz, embedded CPU) and it was just
> half the speed compared with current crc32.

I wonder, given the patch "crc32: Speed up memory table access on powerpc"
would you mind retesting to see if slice by 8 still trails slice by 4 on your
powerpc?  I see that your mpc8321 has 16K of L1D cache and a 32-bit memory bus
whereas my 7447 has a 64-bit memory bus.  I wonder if memory bus size could be
a defining characteristic...?

I tried it out the crc32c code on a s390x today; apparently by-8 trails by-4
there too.  It's unfortunately difficult to figure out the hardware details of
whatever's going on underneath that VM.

--D
> 
>  Jocke
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
