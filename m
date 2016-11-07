From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fscrypto: don't use on-stack buffer for filename
 encryption
Date: Mon, 7 Nov 2016 07:44:44 -0800
Message-ID: <20161107154444.GA13796@infradead.org>
References: <1478210582-86338-1-git-send-email-ebiggers@google.com>
 <20161105151349.e5ap547uno3hfit7@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        richard@nod.at, luto@kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161105151349.e5ap547uno3hfit7@kmo-pixel>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Nov 05, 2016 at 07:13:49AM -0800, Kent Overstreet wrote:
> Vmalloc memory does have struct pages - you just need to use vmalloc_to_page()
> instead of virt_to_page. Look at drivers/md/bcache/util.c bch_bio_map() if you
> want an example.

That example seems to be clearly broken on virtually index caches
due to the lack of flush_kernel_vmap_range and
invalidate_kernel_vmap_range calls.
