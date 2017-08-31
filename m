From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: avoid Y2038 overflow in recently_deleted()
Date: Thu, 31 Aug 2017 11:18:36 -0400
Message-ID: <20170831151836.3jjkmeqoqc5islia@thunk.org>
References: <1503686915-57151-1-git-send-email-adilger@dilger.ca>
 <CAK8P3a1WHVqwK6veXcruHQ=roub6ivnffpBWCw=XcTzF9=ev1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45698 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751276AbdHaPSk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 31 Aug 2017 11:18:40 -0400
Content-Disposition: inline
In-Reply-To: <CAK8P3a1WHVqwK6veXcruHQ=roub6ivnffpBWCw=XcTzF9=ev1A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 30, 2017 at 11:03:08PM +0200, Arnd Bergmann wrote:
> On Fri, Aug 25, 2017 at 8:48 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> > Avoid a 32-bit time overflow in recently_deleted() since i_dtime
> > (inode deletion time) is stored only as a 32-bit value on disk.
> > Since i_dtime isn't used for much beyond a boolean value in e2fsck
> > and is otherwise only used in this function in the kernel, there is
> > no benefit to use more space in the inode for this field on disk.
> >
> > Instead, compare only the relative deletion time with the low
> > 32 bits of the time using the newly-added time_before32() helper,
> > which is similar to time_before() and time_after() for jiffies.
> >
> > Increase RECENTCY_DIRTY to 300s based on Ted's comments about
> > usage experience at Google.
> >
> > Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> > Change-Id: I7402e1b3d49ea326f872ec8324933f42b502b9be
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied.

					- Ted
