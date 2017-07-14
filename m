From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH 4/6] fscrypt: verify that the correct master key was supplied
Date: Fri, 14 Jul 2017 13:34:48 -0400
Message-ID: <CAH8yC8naCiyXKeaYbyw=B1DgM3vvBtUSmDCZ+B7VVqZ6QD1uhg@mail.gmail.com>
References: <20170712210035.51534-1-ebiggers3@gmail.com> <20170712210035.51534-5-ebiggers3@gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Alex Cope <alexcope@google.com>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20170712210035.51534-5-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 12, 2017 at 5:00 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
>....
> Solve the problem for v2 encryption policies by storing a "hash" of the
> master encryption key in the encryption xattr and verifying it before
> accepting the user-provided key.
> ...

Forgive my ignorance... Doesn't that setup an oracle so an attacker
can query keys?

It seems like the problem is deeper into the design. Namely, the
caching and sharing of keys.

Jeff
