From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: Re: [PATCH] ext4: make huge file flag user visible.
Date: Wed, 24 Jan 2018 23:48:14 -0800
Message-ID: <20180125074811.GA24022@L-66Y>
References: <1516767348-30444-1-git-send-email-tgnottingham@gmail.com>
 <20180124050333.GC5594@magnolia>
 <20180124050930.GF5594@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:37304 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbeAYHsS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jan 2018 02:48:18 -0500
Received: by mail-pg0-f46.google.com with SMTP id z17so4569532pgc.4
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jan 2018 23:48:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180124050930.GF5594@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 23, 2018 at 09:09:30PM -0800, Darrick J. Wong wrote:

> > Pardon my asking, but why is this necessary?  Are there
> > userspace-visible effects of this flag?
> 
> Ahh, the chattr man page says that 'h' means HUGE_FILE_FL, but I guess
> ext4 won't report it to userspace...?
> 
> <shrug> XFS won't either, maybe we just kill the 'h' option? :)

Thanks for responses. Yes, I was just trying to make ext4 consistent with the
man page. Since apparently the flag was intended to be user visible at some
point, I thought it would be fine to make it so. As you said, removing it from
chattr/lsattr is another option. I'll do whatever I'm told. :)

Tyson
