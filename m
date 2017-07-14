From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 3/6] fscrypt: use HKDF-SHA512 to derive the
 per-inode encryption keys
Date: Fri, 14 Jul 2017 17:50:06 +0200
Message-ID: <6581107.6MsbyqD4B1@positron.chronox.de>
References: <20170712210035.51534-1-ebiggers3@gmail.com>
	<2034167.Brpu2WxA6s@tauon.chronox.de>
	<20170713181057.GA143898@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, herbert@gondor.apana.org.au,
	Eric Biggers <ebiggers@google.com>, Alex Cope <alexcope@google.com>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20170713181057.GA143898@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Am Donnerstag, 13. Juli 2017, 20:10:57 CEST schrieb Eric Biggers:

Hi Eric,

> Hi Stephan,
> =

> On Thu, Jul 13, 2017 at 04:54:55PM +0200, Stephan M=FCller wrote:
> > Am Mittwoch, 12. Juli 2017, 23:00:32 CEST schrieb Eric Biggers:
> > =

> > Hi Herbert,
> > =

> > This patch adds a second KDF to the kernel -- the first is found in the
> > keys subsystem.
> > =

> > The next KDF that may come in is in the TLS scope.
> > =

> > Would it make sense to warm up the KDF patches adding generic KDF suppo=
rt
> > to the kernel crypto API that I supplied some time ago? The advantages
> > would be to have one location of KDF implementations and the benefit of
> > the testmgr.
> That may be a good idea.  Looking at the old thread, I share Herbert's
> concern (http://www.spinics.net/lists/linux-crypto/msg21231.html) about
> there likely not being more than one implementation of each KDF algorithm=
. =

> So, perhaps some simple helper functions would be more appropriate. =

> However, making the KDFs be covered by self-tests would be very nice.

I agree that it is likely that specific KDF implementations may only be use=
d =

once. But still, I would recommend to maintain those implementation under t=
he =

crypto API umbrella, as KDFs are cryptographic operations.

> =

> Also, it seems your patch
> (http://www.spinics.net/lists/linux-crypto/msg21137.html) doesn't allow a
> salt to be passed in.  In order to fully support HKDF, crypto_rng_reset()
> (which as I understand would be the way to invoke the "extract" step) wou=
ld
> somehow need to accept both the input keying material and salt, both of
> which are arbitrary length binary.

I concur with you. I have implemented the HKDF in my libkcapi as well and s=
aw =

the need for a salt.

Let me work on an update to the KDF patch for the kernel crypto API.

Ciao
Stephan

---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
