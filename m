From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] blockgroup_lock.h: simplify definition of NR_BG_LOCKS
Date: Thu, 15 Sep 2016 18:29:56 -0400
Message-ID: <20160915222956.4ekfwjbwps4a6x2f@thunk.org>
References: <1473881320-123184-1-git-send-email-ebiggers@google.com>
 <3F033C47-E636-42D1-AFCD-FCBCBF795ED4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57392 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754987AbcIOWaI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Sep 2016 18:30:08 -0400
Content-Disposition: inline
In-Reply-To: <3F033C47-E636-42D1-AFCD-FCBCBF795ED4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2016 at 03:09:30PM -0600, Andreas Dilger wrote:
> On Sep 14, 2016, at 1:28 PM, Eric Biggers <ebiggers@google.com> wrote:
> > 
> > We can use ilog2() to more easily produce the desired NR_BG_LOCKS.  This
> > works because ilog2() is evaluated at compile-time when its argument is
> > a compile-time constant.
> > 
> > I did not change the chosen NR_BG_LOCKS values.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

						- Ted
