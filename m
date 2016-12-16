From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ubifs: add CONFIG_BLOCK dependency for encryption
Date: Fri, 16 Dec 2016 01:35:45 -0800
Message-ID: <20161216093545.GA8352@infradead.org>
References: <20161216084231.1637761-1-arnd@arndb.de>
 <1df9c2e6-fdf8-404d-4678-7b45958f07f3@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>,
        Randy Dunlap <rdunlap@infradead.org>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1df9c2e6-fdf8-404d-4678-7b45958f07f3@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 16, 2016 at 10:26:35AM +0100, Richard Weinberger wrote:
> > The easiest way out is to limit UBIFS_FS_ENCRYPTION to configurations
> > that also enable BLOCK.
> 
> Thanks for the fix!
> I'll queue this for -rc2.
> 
> In the long-run I'd like to remove the CONFIG_BLOCK dependency from fs/crypto/crypto.c
> since UBIFS does not use the block related functions at all.

I would much prefer if you did that fixup now.  Either by moving
all the block code into a new fs/crypto/bio.c or if that's too hard
by just sprinkling ifdefs.
