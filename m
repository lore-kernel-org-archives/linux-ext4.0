From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fscrypt: Factor out bio specific functions
Date: Mon, 19 Dec 2016 02:39:29 -0800
Message-ID: <20161219103929.GA16197@infradead.org>
References: <20161216105006.10207-1-richard@nod.at>
 <72D4D0FB-F56D-4457-9660-4CFF7B4CFB6E@sigma-star.at>
 <48d4de8e-6e57-cbad-7556-03aa788c815a@nod.at>
 <20161216221428.GC14264@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, jaegeuk@kernel.org, tytso@mit.edu,
        hch@infradead.org, arnd@arndb.de, dedekind1@gmail.com,
        linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-ext4@vger.kernel.org, ebiggers@google.com,
        rdunlap@infradead.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161216221428.GC14264@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 16, 2016 at 02:14:28PM -0800, Eric Biggers wrote:
> Hmm, it still seems weird to define fscrypt_zeroout_range() when it can't
> actually be used.  It looks like the problem is specifically the use of
> alloc_bounce_page() and do_page_crypto().  Would it be that bad to make those
> available in fscrypt_internal.h (not exported to filesystems)?

Sounds good to me.

> Also, it seems the actual problem is that fscrypt_zeroout_range() tries to be
> clever and reuse one bounce page over and over.  But this seems very inefficient
> because it has to wait for each block to be synchronously written out before
> moving on to the next.  I'm thinking it really should be updated to work more
> like the normal write path, and then it could use fscrypt_encrypt_page()...

That sounds even better, but might take a little more time.
