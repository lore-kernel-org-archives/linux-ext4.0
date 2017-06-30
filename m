From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: mkfs.ext4 -D option fails to mount
Date: Fri, 30 Jun 2017 11:47:31 -0600
Message-ID: <20170630174731.GA27371@linux.intel.com>
References: <20170629153538.GA4268@linux.intel.com>
 <20170629155727.GA8536@linux.intel.com>
 <20170629175319.s75rdncvejil357p@thunk.org>
 <20170629230637.GA14347@linux.intel.com>
 <20170629234816.werual2uikyhc56k@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:8372 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbdF3Rrd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Jun 2017 13:47:33 -0400
Content-Disposition: inline
In-Reply-To: <20170629234816.werual2uikyhc56k@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 29, 2017 at 07:48:16PM -0400, Theodore Ts'o wrote:
> I'm not able to reproduce it using your reproduction receipe using
> e2fsprogs 1.43.4.  I suspect you might be hitting a bug which was
> fixed by this commit:
> 
> commit d6cad379eb6c86ca58bf5b83a586577de412a2e6
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sun Sep 11 00:25:48 2016 -0400
> 
>     libext2fs: fix unaligned, multiblock writes in the unix_io handler
>     
>     The read-modify-write code for the unaligned fallback code wasn't
>     working for multi-block writes.  This was unmasked by FreeBSD 11-rc2,
>     since its malloc() is returning unaligned memory regions for large
>     memory regions.
>     
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> Can you retry with e2fsprogs 1.43.4 and see if it fixes your issue?

Yep, confirmed that it works with e2fsprogs v1.43.4.  Cool, thanks.
