From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: Re: [PATCH] ext4: make huge file flag user visible.
Date: Mon, 5 Feb 2018 14:29:46 -0800
Message-ID: <20180205222946.GA20317@L-66Y>
References: <1516767348-30444-1-git-send-email-tgnottingham@gmail.com>
 <20180124050333.GC5594@magnolia>
 <20180124050930.GF5594@magnolia>
 <20180125074811.GA24022@L-66Y>
 <20180129230816.GM9359@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38608 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeBEW3v (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Feb 2018 17:29:51 -0500
Received: by mail-pg0-f68.google.com with SMTP id l18so1902312pgc.5
        for <linux-ext4@vger.kernel.org>; Mon, 05 Feb 2018 14:29:50 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180129230816.GM9359@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 29, 2018 at 03:08:16PM -0800, Darrick J. Wong wrote:

> Ted hasn't replied in a couple of days, but I would surmise from digging
> in the ext4 code that we've never exposed the huge file flag to
> userspace, so it'd probably be better to withdraw the documentation/code
> of the 'h' option from the chattr manpage instead.  ext2/ext3 never had
> such a flag at all, so it's unlikely to break anything.

I agree. I'll update my existing patch that makes some updates to the chattr
man page.

Thanks,
Tyson
