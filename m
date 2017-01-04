From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2] fscrypt: Factor out bio specific functions
Date: Wed, 4 Jan 2017 12:10:43 -0800
Message-ID: <20170104201043.GA21696@gmail.com>
References: <20161219103929.GA16197@infradead.org>
 <20161219112532.18863-1-richard@nod.at>
 <20170101214725.g67msbedmpx27waz@thunk.org>
 <dd8b8365-e84a-7f8e-384d-4900523e761e@nod.at>
 <20170103142836.no7rp3hphj3czjto@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Richard Weinberger <richard@nod.at>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jaegeuk@kernel.org, hch@infradead.org, arnd@arndb.de,
        dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        adrian.hunter@intel.com, linux-ext4@vger.kernel.org,
        ebiggers@google.com, rdunlap@infradead.org, david@sigma-star.at
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35491 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757339AbdADULY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2017 15:11:24 -0500
Content-Disposition: inline
In-Reply-To: <20170103142836.no7rp3hphj3czjto@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 03, 2017 at 09:28:36AM -0500, Theodore Ts'o wrote:
> On Tue, Jan 03, 2017 at 10:49:26AM +0100, Richard Weinberger wrote:
> > Ted,
> > 
> > Am 01.01.2017 um 22:47 schrieb Theodore Ts'o:
> > > On Mon, Dec 19, 2016 at 12:25:32PM +0100, Richard Weinberger wrote:
> > >> That way we can get rid of the direct dependency on CONFIG_BLOCK.
> > >>
> > >> Reported-by: Arnd Bergmann <arnd@arndb.de>
> > >> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > >> Suggested-by: Christoph Hellwig <hch@infradead.org>
> > >> Fixes: d475a507457b ("ubifs: Add skeleton for fscrypto")
> > >> Signed-off-by: Richard Weinberger <richard@nod.at>
> > > 
> > > Applied, thanks.
> > 
> > Just to make sure, this fixes a build error and should
> > go into Linus' tree ASAP.
> 
> I didn't consider this a build error since it could be fixed via a
> config change.  And it is a pretty big patch, even if it is mostly
> moving (not that git recognized it as such)...
> 

I thought you're supposed to be able to build the kernel no matter how it's
configured.  If this patch is really too large for 4.10 then perhaps we should
make FS_ENCRYPTION select CONFIG_BLOCK instead?

Eric
