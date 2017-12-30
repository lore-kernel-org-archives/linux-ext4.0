From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: add e2mmpstatus utility
Date: Fri, 29 Dec 2017 20:57:04 -0500
Message-ID: <20171230015704.GE11757@thunk.org>
References: <1513934564-89598-1-git-send-email-adilger@dilger.ca>
 <20171222171716.GB29153@thunk.org>
 <F976B3B9-90C4-446E-B8D4-49571CA535A4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Wang Shilong <wshilong@ddn.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36632 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750800AbdL3B5H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Dec 2017 20:57:07 -0500
Content-Disposition: inline
In-Reply-To: <F976B3B9-90C4-446E-B8D4-49571CA535A4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 29, 2017 at 04:02:04PM -0700, Andreas Dilger wrote:
> > Why not include this into dumpe2fs?  Maybe dumpe2fs -m to just print
> > the MMP information and include the MMP nodetime and time for either
> > the full dumpe2fs or dumpe2fs -h output?
> 
> That would definitely be an option.  The mmpstatus utility was written by
> DDN, and I'm passing it on after some code cleanup.
> 
> I think it would be reasonable to include the other MMP fields into the
> dumpe2fs output, and then run the full MMP activity check if called with
> "-m" or named as "mmpstatus".  I don't want dumpe2fs to be blocked on
> the MMP update checking all the time, since that can be slow.

SGTM.

> I'll see if I can get a patch out in the next couple of days.

Many thanks!!

Cheers,

				- Ted
