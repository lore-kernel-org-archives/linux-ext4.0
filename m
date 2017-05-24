From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: libext2fs: don't flush to device opened in read-only mode
Date: Wed, 24 May 2017 17:56:22 -0400
Message-ID: <20170524215622.fh7yin4fttggw36f@thunk.org>
References: <118AAB5F26BFB34DB5CDA7DA33334DB9B5FF41@vmsk-exch-01.paragon-software.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Konstantin Chistyakov <Konstantin.Chistyakov@paragon-software.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34890 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033205AbdEXV4Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 May 2017 17:56:24 -0400
Content-Disposition: inline
In-Reply-To: <118AAB5F26BFB34DB5CDA7DA33334DB9B5FF41@vmsk-exch-01.paragon-software.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 22, 2017 at 09:48:00AM +0000, Konstantin Chistyakov wrote:
> From: Konstantin Chistyakov <Konstantin.Chistyakov@Paragon-software.com>
> Date: Tue, 19 May 2017 09:23:29 -0600
> Subject: [PATCH] libext2fs: don't flush to device opened in read-only mode
> 
> From: Konstantin Chistyakov <Konstantin.Chistyakov@Paragon-software.com>
> 
> If the e2fsck is called with both -f -n options, the checking completing with a flushing error (retcode 8).
> 
> Catch error from the unix_flush() fsync(data->dev) when data->dev is opened in read-only mode:

I can't reproduce this problem.  What storage device or operating
system are you using?

That being said, this is probably the wrong place to fix it.  The
better fix is in e2fsck/unix.c, by adding a read-only test.

       	      	 		   	  - Ted
