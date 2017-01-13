From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: don't ignore fsync errors
Date: Fri, 13 Jan 2017 12:31:54 -0500
Message-ID: <20170113173154.biiyax3lrnfjrivd@thunk.org>
References: <46250d87-9e7b-3cb3-3d74-5c490023c0ed@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43902 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750903AbdAMRcM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 13 Jan 2017 12:32:12 -0500
Content-Disposition: inline
In-Reply-To: <46250d87-9e7b-3cb3-3d74-5c490023c0ed@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 20, 2016 at 09:23:29AM -0600, Eric Sandeen wrote:
> Today, if mke2fs experiences IO errors (say, on a thin device
> which filled up during mkfs), mke2fs is silent and returns
> success even though the filesystem was not properly created.
> 
> Catch errors from the io_channel_flush() callchain to
> fix this up.  Fix formatting of the printed error as
> well:
> 
> ...
> Creating journal (262144 blocks): done
> Writing superblocks and filesystem accounting information:          
> Warning, had trouble writing out superblocks.
> # echo $?
> 5
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
