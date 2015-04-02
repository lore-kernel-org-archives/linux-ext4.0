From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix transposition typo in format string
Date: Thu, 2 Apr 2015 16:47:48 -0400
Message-ID: <20150402204748.GC450@thunk.org>
References: <1424441495-32581-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424441495-32581-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 20, 2015 at 03:11:35PM +0100, Rasmus Villemoes wrote:
> According to C99, %*.s means the same as %*.0s, in other words, print
> as many spaces as the field width argument says and effectively ignore
> the string argument. That is certainly not what was meant here. The
> kernel's printf implementation, however, treats it as if the . was not
> there, i.e. as %*s. I don't know if de->name is nul-terminated or not,
> but in any case I'm guessing the intention was to use de->name_len as
> precision instead of field width.

Applied, sorry for the delay.

(Note: the code is explicitly #ifdef'ed out so the only way the bug
would show up is if a developer explicitly modified the source to
#define INLINE_DIR_DEBUG, so it's not -stable material.)

						- Ted
