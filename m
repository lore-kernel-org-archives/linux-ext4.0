From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fix jbd2 asynchronous commit
Date: Sat, 24 Oct 2015 21:40:17 +0200
Message-ID: <20151024194017.GB17642@quack.suse.cz>
References: <14b201d10e33$fb91c390$f2b54ab0$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eunji Lee <alicia0729@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbbJYEOw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Oct 2015 00:14:52 -0400
Content-Disposition: inline
In-Reply-To: <14b201d10e33$fb91c390$f2b54ab0$@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 24-10-15 17:14:15, Eunji Lee wrote:
> This patch is to fix a (seemingly) bug of asynchronous commit process
> (pinging w/ a patch). 
> 
> In asynchronous commit, JBD2 issues a "FLUSH" request only once after
> issuing a commit record if a file system and a journal reside on the same
> device. This can reduce redundant storage flushes relying on the checksum. 
> 
> However, it seems to incur an undesirable result in ordered mode.
> Specifically, the system can crash after metadata blocks and a commit record
> are successfully written to the journal (i.e., with no checksum error), but
> before data blocks are reflected to the file system. Then, on the system
> recovery, metadata updates in a journal area will be replayed as the
> checksum has no error, even though the associated data blocks are not
> reflected to the file system. This fails to provide the correct ordering -
> associated data blocks are written before metadata updates are written. 
> 
> This patch flushes a storage device before issuing a commit record, even if
> a journal and a file system use a same device, thereby guaranteeing the
> correct ordering between metadata and data block updates. 
> 
> Without asynchronous commit, it does not matter because the commit record
> with WRITE_FUA guarantees to flush storage cache before the commit record is
> written to the journal. 

Thanks for your report and detailed analysis. However this bug is already
fixed - parse_options() in fs/ext4/super.c already makes sure that
journal_async_commit cannot be enabled in data=ordered mode.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
