From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/2] fscrypto: don't use on-stack buffer for filename encryption
Date: Sun, 6 Nov 2016 21:00:55 -0800
Message-ID: <CALCETrVL1pz7UwCoeKm9ZqwqAx5bxy31V=xe_si2r33M2cREiw@mail.gmail.com>
References: <1478210582-86338-1-git-send-email-ebiggers@google.com> <20161105151349.e5ap547uno3hfit7@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Richard Weinberger <richard@nod.at>, jaegeuk@kernel.org,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>
To: Kent Overstreet <kent.overstreet@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20161105151349.e5ap547uno3hfit7@kmo-pixel>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 5, 2016 8:13 AM, "Kent Overstreet" <kent.overstreet@gmail.com> wrote:
>
> On Thu, Nov 03, 2016 at 03:03:01PM -0700, Eric Biggers wrote:
> > With the new (in 4.9) option to use a virtually-mapped stack
> > (CONFIG_VMAP_STACK), stack buffers cannot be used as input/output for
> > the scatterlist crypto API because they may not be directly mappable to
> > struct page.  For short filenames, fname_encrypt() was encrypting a
> > stack buffer holding the padded filename.  Fix it by encrypting the
> > filename in-place in the output buffer, thereby making the temporary
> > buffer unnecessary.
> >
> > This bug could most easily be observed in a CONFIG_DEBUG_SG kernel
> > because this allowed the BUG in sg_set_buf() to be triggered.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
>
> > -             alloc_buf = kmalloc(ciphertext_len, GFP_NOFS);
> > -             if (!alloc_buf)
> > -                     return -ENOMEM;
> > -             workbuf = alloc_buf;
>
> Vmalloc memory does have struct pages - you just need to use vmalloc_to_page()
> instead of virt_to_page. Look at drivers/md/bcache/util.c bch_bio_map() if you
> want an example.
>
> It would be better to just fix the sg code to handle vmalloc memory, instead of
> adding a kmalloc() that can fail (and an error path that inevitably won't be
> tested).

Probably not, because (a) vmalloc_to_page is slow and (b) stack
buffers can span physically noncontiguous pages.

I think it's best to either avoid stack buffers or to teach crypto about kiov.
