From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Fast symlinks stored slow
Date: Thu, 13 Jul 2017 12:49:59 -0400
Message-ID: <20170713164959.m2hf72b6zqlorn5i@thunk.org>
References: <20170712170711.GA19996@redhat.com>
 <20170712231737.nzi2dv6e6h6yvrsl@thunk.org>
 <20170713080213.GO31999@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46868 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751267AbdGMQuC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Jul 2017 12:50:02 -0400
Content-Disposition: inline
In-Reply-To: <20170713080213.GO31999@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 13, 2017 at 09:02:13AM +0100, Richard W.M. Jones wrote:
> 
> From my point of view it's not too much trouble to recreate these
> filesystems, and we've already proposed a fix for supermin so it
> creates symlinks properly[1].

My concern is that people using libguestfs, et.al., on Fedura XX and
then try to decide to upgrade to the 4.13 kernel.  So it sounds like
the exposure could be pretty large.  Am I wrong?

Thanks,

					- Ted
