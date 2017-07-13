From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fast symlinks stored slow
Date: Thu, 13 Jul 2017 14:50:37 -0400
Message-ID: <20170713185037.yz3l6hq3mcc3wppm@thunk.org>
References: <20170712170711.GA19996@redhat.com>
 <20170712231737.nzi2dv6e6h6yvrsl@thunk.org>
 <20170713080213.GO31999@redhat.com>
 <20170713164959.m2hf72b6zqlorn5i@thunk.org>
 <20170713171335.GT31999@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47242 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752415AbdGMSul (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Jul 2017 14:50:41 -0400
Content-Disposition: inline
In-Reply-To: <20170713171335.GT31999@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 13, 2017 at 06:13:35PM +0100, Richard W.M. Jones wrote:
> In this case we're using libext2fs to build an appliance filesystem,
> used to boot a small Linux system which is then run under qemu by
> libguestfs.  This appliance is completely rebuilt automatically under
> many circumstances, for example a host package upgrade (eg. upgrading
> the kernel), so it's not a long-lived filesystem that would cause a
> problem.  Rebuilding only takes a few seconds.
> 
> The process is described in more detail here:
> http://libguestfs.org/supermin.1.html#SUPERMIN-APPLIANCES
> 
> From our point of view the only issue are some prebuilt appliances
> which we have provided to other distributions that cannot / don't want
> to use supermin (http://download.libguestfs.org/binaries/appliance/)
> and at some point I'm going to have to rebuild these using the fixed
> supermin.

OK, so the risk is if there are other people who are using supermin to
create appliances.  (One potential use case we might need to
investigate are services such as SuSE Studio, since it can create
turnkey VM appliances for its users.)  If these applianes are
distributed end users (as opposed to being automatically rebuilt as in
your use case), that's when we would potentially be at risk.

Did I get that right?

					- Ted
