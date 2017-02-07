From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/7] ext4: add shutdown bit and check for it
Date: Tue, 7 Feb 2017 14:52:47 -0500
Message-ID: <20170207195247.qiykhi2nhp6qpebx@thunk.org>
References: <20170205073430.9109-1-tytso@mit.edu>
 <20170205073430.9109-6-tytso@mit.edu>
 <DDAA3DB8-BC57-47CA-97F5-6DB707CFDE6E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43812 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754414AbdBGTwu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 7 Feb 2017 14:52:50 -0500
Content-Disposition: inline
In-Reply-To: <DDAA3DB8-BC57-47CA-97F5-6DB707CFDE6E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 06, 2017 at 12:51:46PM -0700, Andreas Dilger wrote:
> On Feb 5, 2017, at 12:34 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > 
> > Add a shutdown bit that will cause ext4 processing to fail immediately
> > with EIO.
> 
> Does it make sense to combine the checks for "shutdown", "abort", and
> "read-only" into a single check, instead of sprinkling separate checks
> throughout the code?  It seems like many of the places where
> ext4_forced_shutdown() is checked should also be checking for read-only
> and abort, even if they aren't today.

I've thought about that.  At the moment forced_shutdown will actually
return errors for some read-only operations as well --- for example,
we immediately return an error in ext4_file_open() and
ext4_file_mmap().  And I had considered adding it to some additional
read operations (e.g., readpage, readpages, etc.) on the theory that
if we know the block device should be treated as dead, maybe we should
add shortcut error returns for them as well.  (Especially since the
SCSI layer and error handling have historically not necessarily gone
together well like chocolate and peanut butter.  :-)

So I decided to keep the shutdown and implementation of
errors=remount-ro separate for now, but it is a good question for us
to consider.

							- Ted
