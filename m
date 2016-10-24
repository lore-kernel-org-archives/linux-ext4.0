From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] fscrypto: remove unneeded Kconfig dependencies
Date: Mon, 24 Oct 2016 14:17:27 -0700
Message-ID: <20161024211727.GB83082@google.com>
References: <1477340226-144248-1-git-send-email-ebiggers@google.com>
 <c1c3502a-0364-fc31-fa7f-19125f7e0413@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu,
        jaegeuk@kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c1c3502a-0364-fc31-fa7f-19125f7e0413@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 24, 2016 at 10:41:08PM +0200, Richard Weinberger wrote:
> FWIW, Strictly speaking we could also get rid of the dependency on BLOCK.
> Only very few functions in fs/crypto/crypto.c use block specific functions,
> these could be placed in a different file.
> The use case would be very small systems with UBIFS and encrypted files.
> i.e. kexec() style bootloaders.
> 
> Thanks,
> //richard

Yes, that makes sense if UBIFS is going to be using the code too.  Feel free to
propose a patch.  As I understand it, the assumption would be that if a
filesystem needs the block-specific functions in fs/crypto/, then it itself
would necessarily already depend on CONFIG_BLOCK.  It should work to just
conditionally compile the block-specific functions based on CONFIG_BLOCK, either
via #ifdefs or by having a separate file like fs/crypto/block.c and putting
'fscrypto-$(CONFIG_BLOCK) += block.o' in fs/crypto/Makefile.  The separate file
sounds preferable.

Eric
