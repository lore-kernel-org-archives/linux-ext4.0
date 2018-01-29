From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: make huge file flag user visible.
Date: Mon, 29 Jan 2018 15:08:16 -0800
Message-ID: <20180129230816.GM9359@magnolia>
References: <1516767348-30444-1-git-send-email-tgnottingham@gmail.com>
 <20180124050333.GC5594@magnolia>
 <20180124050930.GF5594@magnolia>
 <20180125074811.GA24022@L-66Y>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
To: Tyson Nottingham <tgnottingham@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51754 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751803AbeA2XNY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jan 2018 18:13:24 -0500
Content-Disposition: inline
In-Reply-To: <20180125074811.GA24022@L-66Y>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 24, 2018 at 11:48:14PM -0800, Tyson Nottingham wrote:
> On Tue, Jan 23, 2018 at 09:09:30PM -0800, Darrick J. Wong wrote:
> 
> > > Pardon my asking, but why is this necessary?  Are there
> > > userspace-visible effects of this flag?
> > 
> > Ahh, the chattr man page says that 'h' means HUGE_FILE_FL, but I guess
> > ext4 won't report it to userspace...?
> > 
> > <shrug> XFS won't either, maybe we just kill the 'h' option? :)
> 
> Thanks for responses. Yes, I was just trying to make ext4 consistent with the
> man page. Since apparently the flag was intended to be user visible at some
> point, I thought it would be fine to make it so. As you said, removing it from
> chattr/lsattr is another option. I'll do whatever I'm told. :)

Ted hasn't replied in a couple of days, but I would surmise from digging
in the ext4 code that we've never exposed the huge file flag to
userspace, so it'd probably be better to withdraw the documentation/code
of the 'h' option from the chattr manpage instead.  ext2/ext3 never had
such a flag at all, so it's unlikely to break anything.

--D

> Tyson
