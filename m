From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 bug fixes for 3.18
Date: Fri, 31 Oct 2014 16:26:16 -0700
Message-ID: <CA+55aFwiFx6ejtnEvZYJewHaskwjTr39bPstFvWYimqi6hMCsQ@mail.gmail.com>
References: <20141031214949.GA644@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141031214949.GA644@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 31, 2014 at 2:49 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Theodore Ts'o (1):
>       jbd2: use a better hash function for the revoke table

Does it really make sense to use hash_u64()? It can be quite expensive
(mainly on 32-bit targets), and since the low bits are where all the
information is anyway, I'd suggest using hash_32() here even if the
block number in theory can have a few bits above the 32-bit mark.

Anyway, pulled, but I just reacted to that small detail.

                      Linus
