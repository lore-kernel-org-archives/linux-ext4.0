From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] fscrypt: Factor out bio specific functions
Date: Sat, 7 Jan 2017 14:24:06 -0500
Message-ID: <20170107192406.56p7ppbdfkjii4vy@thunk.org>
References: <20161219103929.GA16197@infradead.org>
 <20161219112532.18863-1-richard@nod.at>
 <20170101214725.g67msbedmpx27waz@thunk.org>
 <dd8b8365-e84a-7f8e-384d-4900523e761e@nod.at>
 <20170103142836.no7rp3hphj3czjto@thunk.org>
 <20170104201043.GA21696@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Weinberger <richard@nod.at>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jaegeuk@kernel.org,
        hch@infradead.org, arnd@arndb.de, dedekind1@gmail.com,
        linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-ext4@vger.kernel.org, ebiggers@google.com,
        rdunlap@infradead.org, david@sigma-star.at
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170104201043.GA21696@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 04, 2017 at 12:10:43PM -0800, Eric Biggers wrote:
> 
> I thought you're supposed to be able to build the kernel no matter how it's
> configured.  If this patch is really too large for 4.10 then perhaps we should
> make FS_ENCRYPTION select CONFIG_BLOCK instead?

We already have FS_ENCRYPTIOn depending on BLOCK, so this is *not*
fixing a build break.

Given that, it's a bit harder to claim this is a must-have bug fix for
the stable branch?

						- Ted
