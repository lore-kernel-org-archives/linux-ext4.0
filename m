From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: mkfs.ext4 -D option fails to mount
Date: Thu, 29 Jun 2017 19:48:16 -0400
Message-ID: <20170629234816.werual2uikyhc56k@thunk.org>
References: <20170629153538.GA4268@linux.intel.com>
 <20170629155727.GA8536@linux.intel.com>
 <20170629175319.s75rdncvejil357p@thunk.org>
 <20170629230637.GA14347@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60836 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751679AbdF2XsT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Jun 2017 19:48:19 -0400
Content-Disposition: inline
In-Reply-To: <20170629230637.GA14347@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm not able to reproduce it using your reproduction receipe using
e2fsprogs 1.43.4.  I suspect you might be hitting a bug which was
fixed by this commit:

commit d6cad379eb6c86ca58bf5b83a586577de412a2e6
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Sep 11 00:25:48 2016 -0400

    libext2fs: fix unaligned, multiblock writes in the unix_io handler
    
    The read-modify-write code for the unaligned fallback code wasn't
    working for multi-block writes.  This was unmasked by FreeBSD 11-rc2,
    since its malloc() is returning unaligned memory regions for large
    memory regions.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Can you retry with e2fsprogs 1.43.4 and see if it fixes your issue?

						- Ted
