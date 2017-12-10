From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] fscrypt: add support for ChaCha20 contents encryption
Date: Sun, 10 Dec 2017 10:59:51 -0800
Message-ID: <20171210185831.GA1170@zzz.localdomain>
References: <20171208013838.105034-1-ebiggers3@gmail.com>
 <CAH8yC8knEBwum3Ka3x+8sT3qhtHT2FLb4Bo6DzjPKFC0hw4KQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Michael Halcrow <mhalcrow@google.com>,
        Paul Crowley <paulcrowley@google.com>,
        Martin Willi <martin@strongswan.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        David Gstir <david@sigma-star.at>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>
To: Jeffrey Walton <noloader@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36957 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbdLJS7z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Dec 2017 13:59:55 -0500
Content-Disposition: inline
In-Reply-To: <CAH8yC8knEBwum3Ka3x+8sT3qhtHT2FLb4Bo6DzjPKFC0hw4KQA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 08, 2017 at 07:48:54PM -0500, Jeffrey Walton wrote:
> > Still, a stream cipher is sufficient to protect data confidentiality in
> > the event of a single point-in-time permanent offline compromise of the
> > disk, which currently is the primary threat model for fscrypt.  Thus,
> > when the alternative is quite literally *no encryption*, we might as
> > well use a stream cipher.
> 
> The "single point in time" requirement is kind of interesting. I
> believe you are saying the scheme lacks semantic security.

Well, it is semantically secure when looking at encryptions/decryptions done in
the context of different blocks (different IVs) but not semantically secure when
looking at encryptions/decryptions done in the context of the same block (same
IV).  But in that regard it is the same as the other modes such as AES-XTS or
AES-CBC.  So I think you are missing the point, which is that a stream cipher
fails more catastrophically than the other modes when IVs are reused.

> 
> Forgive my ignorance... Does that mean this cipher should not be used
> when backups are in effect; or sync'ing to <insert favorite cloud
> provider> happens?

Normally backup or sync software will operate on the plaintext, which makes
whatever type of filesystem-level or disk encryption you happen to be using
irrelevant.  But at a more abstract level, intentional copies (in addition to
"unintentional" copies that may be done by the filesystem or flash storage) are
certainly a way that you could end up with multiple ciphertexts for the same
block in existence at the same time, so that would indeed need to be accounted
for in the assumptions.

Eric
