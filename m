From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] fscrypt: Factor out bio specific functions
Date: Tue, 3 Jan 2017 09:28:36 -0500
Message-ID: <20170103142836.no7rp3hphj3czjto@thunk.org>
References: <20161219103929.GA16197@infradead.org>
 <20161219112532.18863-1-richard@nod.at>
 <20170101214725.g67msbedmpx27waz@thunk.org>
 <dd8b8365-e84a-7f8e-384d-4900523e761e@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jaegeuk@kernel.org, hch@infradead.org, arnd@arndb.de,
        dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        adrian.hunter@intel.com, linux-ext4@vger.kernel.org,
        ebiggers@google.com, rdunlap@infradead.org, david@sigma-star.at
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dd8b8365-e84a-7f8e-384d-4900523e761e@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 03, 2017 at 10:49:26AM +0100, Richard Weinberger wrote:
> Ted,
> 
> Am 01.01.2017 um 22:47 schrieb Theodore Ts'o:
> > On Mon, Dec 19, 2016 at 12:25:32PM +0100, Richard Weinberger wrote:
> >> That way we can get rid of the direct dependency on CONFIG_BLOCK.
> >>
> >> Reported-by: Arnd Bergmann <arnd@arndb.de>
> >> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> >> Suggested-by: Christoph Hellwig <hch@infradead.org>
> >> Fixes: d475a507457b ("ubifs: Add skeleton for fscrypto")
> >> Signed-off-by: Richard Weinberger <richard@nod.at>
> > 
> > Applied, thanks.
> 
> Just to make sure, this fixes a build error and should
> go into Linus' tree ASAP.

I didn't consider this a build error since it could be fixed via a
config change.  And it is a pretty big patch, even if it is mostly
moving (not that git recognized it as such)...

git show --stat -M 58ae74683ae2c07cd717a91799edb50231061938
commit 58ae74683ae2c07cd717a91799edb50231061938
Author: Richard Weinberger <richard@nod.at>
Date:   Mon Dec 19 12:25:32 2016 +0100

    fscrypt: factor out bio specific functions
    
    That way we can get rid of the direct dependency on CONFIG_BLOCK.
    
    Fixes: d475a507457b ("ubifs: Add skeleton for fscrypto")
    Reported-by: Arnd Bergmann <arnd@arndb.de>
    Reported-by: Randy Dunlap <rdunlap@infradead.org>
    Reviewed-by: Eric Biggers <ebiggers@google.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: David Gstir <david@sigma-star.at>
    Signed-off-by: Richard Weinberger <richard@nod.at>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

 fs/crypto/Kconfig           |   1 -
 fs/crypto/Makefile          |   1 +
 fs/crypto/bio.c             | 145 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/crypto/crypto.c          | 157 +++++++++----------------------------------------------------------------------------
 fs/crypto/fscrypt_private.h |  16 ++++++++-
 include/linux/fscrypto.h    |  11 +++---
 6 files changed, 184 insertions(+), 147 deletions(-)

						- Ted
						
