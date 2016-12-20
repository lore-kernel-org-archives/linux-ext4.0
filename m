From: David Gstir <david@sigma-star.at>
Subject: Re: [PATCH v2] fscrypt: Factor out bio specific functions
Date: Tue, 20 Dec 2016 07:42:14 +0100
Message-ID: <C1B6C185-6DF1-4118-80E4-7B2FE33225E1@sigma-star.at>
References: <20161219103929.GA16197@infradead.org> <20161219112532.18863-1-richard@nod.at>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jaegeuk@kernel.org, tytso@mit.edu, hch@infradead.org,
        arnd@arndb.de, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        adrian.hunter@intel.com, linux-ext4@vger.kernel.org,
        ebiggers@google.com, rdunlap@infradead.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161219112532.18863-1-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

> On 19.12.2016, at 12:25, Richard Weinberger <richard@nod.at> wrote:
> 
> That way we can get rid of the direct dependency on CONFIG_BLOCK.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Fixes: d475a507457b ("ubifs: Add skeleton for fscrypto")
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
> Changes since v1:
> - Moved fscrypt_zeroout_range() also to bio.c

Looks good to me.

Reviewed-by: David Gstir <david@sigma-star.at>

- David
