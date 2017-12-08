From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] fscrypt: add support for ChaCha20 contents
 encryption
Date: Fri, 8 Dec 2017 10:27:07 +0000
Message-ID: <CAKv+Gu-5htHxD3gOLWdSNabfiHD=_ssdZLsdksv3FJ_ueK=XEQ@mail.gmail.com>
References: <20171208013838.105034-1-ebiggers3@gmail.com>
 <CAKv+Gu_7vMAOP371MJh+FoYb81gwF1y_zy+OES9q5eWTTdOBTg@mail.gmail.com>
 <CAKv+Gu-GfHpukc0WA6z13xAfdcmL9LQUmH41J4GsuMP+m4ge3g@mail.gmail.com>
 <6974144.ZTrPlmK77A@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: David Gstir <david@sigma-star.at>, Theodore Ts'o <tytso@mit.edu>,
 Eric Biggers <ebiggers@google.com>, Martin Willi <martin@strongswan.org>,
 Eric Biggers <ebiggers3@gmail.com>, Michael Halcrow <mhalcrow@google.com>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org,
 linux-mtd@lists.infradead.org,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <6974144.ZTrPlmK77A@tauon.chronox.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On 8 December 2017 at 10:14, Stephan Mueller <smueller@chronox.de> wrote:
> Am Freitag, 8. Dezember 2017, 11:06:31 CET schrieb Ard Biesheuvel:
>
> Hi Ard,
>
>>
>> Given how it is not uncommon for counters to be used as IV, this is a
>> fundamental flaw that could rear its head in other places as well, so
>> I propose we fix this one way (fix the current code) or the other
>> (deprecate the current code and create a new chacha20-rfc7539
>> blockcipher that uses a 96-bit IV and sets the counter to 0)
>
> Instead of having a complete new implementation of the ChaCha20 cipher, what
> about using a specific IV generator for which the kernel crypto API has
> already support (see crypto/seqiv.c for example)?
>
> I.e. we have the current ChaCha20 cipher, but use some "rfc7539iv(chacha20)"
> cipher mode where that rfc7539iv is the mentioned IV generator that turns the
> given IV (sector number?) into the proper IV for ChaCha20.
>

To be honest, I don't fully understand how the IV generators work.
seqiv is implemented as an AEAD not as a skcipher, and we'd need to
wrap chacha20 in something that is usable as a skcipher.

In any case, it does make sense to address this by wrapping chacha20
in something generic, rather than having to extend all
implementations.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
