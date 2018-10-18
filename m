Return-Path: <SRS0=Xbv+=M6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57582 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbeJRKWo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Oct 2018 06:22:44 -0400
Date: Wed, 17 Oct 2018 22:23:59 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Cc: liu.song11@zte.com.cn, fishland@aliyun.com, wang.yi59@zte.com.cn,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: direct return when jinode allocate failed
Message-ID: <20181018022359.GA12382@thunk.org>
References: <20181016145526.3288-1-fishland@aliyun.com,20181016190840.GF24131@thunk.org>
 <201810171026448096961@zte.com.cn>
 <EA9B5AA4-DA21-4B1D-9E89-8C9F16EB8986@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EA9B5AA4-DA21-4B1D-9E89-8C9F16EB8986@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 17, 2018 at 05:28:55PM -0600, Andreas Dilger wrote:
> 
> Looking at the patch there are two effects that it has:
> - optimize a very rare case where there is an allocation failure before locking
> - return an unnecessary error if "ei->jinode" is allocated before locking
> 
> I don't think it is worthwhile to optimize this case, since allocation failures
> will have a serious impact on the application, and I'd rather avoid the rare
> case where we don't return an unnecessary error than make the error case faster.

To be fair, the "unnecessery error" case is also extremely rare.  In
order for that to happen, two processes would need to be racing to
allocate allocate the jinode structure for an inode (since we bail
earlier when we check for the ei->jinode == NULL case before we take
the lock), where the first process succeeds in allocating memory ---
but the second one fails.

Both of these are super-rare cases, and involve the system thrashing
due to super-high memory pressure --- at which point worrying about a
micro-optimization or an unnecessary failure is going to be the last
of the system's problem.

This is why I said, "the patch probably doesn't hurt, but I also don't
see it helping much".

Cheers,

						- Ted
