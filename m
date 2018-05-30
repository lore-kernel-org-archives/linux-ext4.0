From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: prefer strlcpy to strncpy
Date: Wed, 30 May 2018 01:14:58 -0400
Message-ID: <20180530051458.GB27959@thunk.org>
References: <1527574913-10561-1-git-send-email-nick.desaulniers@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Nick Desaulniers <nick.desaulniers@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527574913-10561-1-git-send-email-nick.desaulniers@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 28, 2018 at 11:21:53PM -0700, Nick Desaulniers wrote:
> Fixes a stringop-truncation warning from gcc-8.
> 
> Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>

I'll note that the ext4 superblock fields are *not* guaranteed to be
NULL terminated.  Code that references them must, and do, deal with
this appropriately.  See for example:

https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/tree/lib/e2p/ls.c#n436

GCC-8 may whine about it, but the whine is, in fact, not correct.
It's making assumptions about all strings being null terminated, which
is often, but not always, the case.

Cheers,

						- Ted
