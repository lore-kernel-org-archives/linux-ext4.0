From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: sanity check the block and cluster size at
 mount time
Date: Fri, 18 Nov 2016 16:55:55 -0500
Message-ID: <20161118215555.j5ed42ejtgmm3czi@thunk.org>
References: <20161118183842.25682-1-tytso@mit.edu>
 <20161118200246.GB73496@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kernel@kyup.com,
        bp@alien8.de, stable@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161118200246.GB73496@google.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 18, 2016 at 12:02:46PM -0800, Eric Biggers wrote:
> 
> This isn't validating s_log_block_size until after it's already been used in a
> shift, which means the code can have undefined behavior (shift by a value too
> large).  Would it make sense to do something like the following instead?
> Similarly for the cluster size case.

Well, technically GCC is allowed to do *anything* with undefined
behavior, including forking and exec'ing a process to play larn or
rogue --- but that seems fairly unlikely.  The main reason why I left
things the way it was is beause most of the time we want to print a
more user-friendly message about the blocksize, as opposed to
s_log_block_size.

>         blocksize =                                                              
>                 BLOCK_SIZE << min_t(u32, le32_to_cpu(es->s_log_block_size), 20);

If I was going to do anything at all, it would probably be something like

         blocksize =                                                              
                 BLOCK_SIZE << (le32_to_cpu(es->s_log_block_size) & 0x1F);

...on the theory that a boolean AND operation is going to be faster
and cheaper than a min_t.

						- Ted
