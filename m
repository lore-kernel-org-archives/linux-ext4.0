From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 2/2] fscrypto: don't use on-stack buffer for key
 derivation
Date: Tue, 15 Nov 2016 10:53:09 -0800
Message-ID: <20161115185309.GE127180@google.com>
References: <1478210582-86338-1-git-send-email-ebiggers@google.com>
 <1478210582-86338-2-git-send-email-ebiggers@google.com>
 <20161115164704.5tzvm2g2x2fyetyu@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, jaegeuk@kernel.org, richard@nod.at,
        luto@kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161115164704.5tzvm2g2x2fyetyu@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 15, 2016 at 11:47:04AM -0500, Theodore Ts'o wrote:
> On Thu, Nov 03, 2016 at 03:03:02PM -0700, Eric Biggers wrote:
> > With the new (in 4.9) option to use a virtually-mapped stack
> > (CONFIG_VMAP_STACK), stack buffers cannot be used as input/output for
> > the scatterlist crypto API because they may not be directly mappable to
> > struct page.  get_crypt_info() was using a stack buffer to hold the
> > output from the encryption operation used to derive the per-file key.
> > Fix it by using a heap buffer.
> > 
> > This bug could most easily be observed in a CONFIG_DEBUG_SG kernel
> > because this allowed the BUG in sg_set_buf() to be triggered.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> This commit is on the fscrypt and dev branches on ext4.git.
> 
>      	       	      	      	  - Ted

Hi Ted,

Would it make any sense to send these two patches to Linus for v4.9-rc6, given
that they fix bugs introduced in 4.9 with the virtually-mapped stack feature?
Or would you prefer to wait and have them go to 4.9 via stable?
Note that CONFIG_VMAP_STACK defaults to y on x86_64.

Thanks,

Eric
