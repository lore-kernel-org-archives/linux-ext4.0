From: Jan Kara <jack@suse.cz>
Subject: Re: [ext3/4] PROBLEM: fdatasync not syncing appended data (w/test
 program)
Date: Mon, 3 Sep 2012 15:57:56 +0200
Message-ID: <20120903135756.GI21109@quack.suse.cz>
References: <87k3wb8pgk.fsf@frigg.knielsen-hq.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kristian Nielsen <knielsen@knielsen-hq.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab2ICN57 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Sep 2012 09:57:59 -0400
Content-Disposition: inline
In-Reply-To: <87k3wb8pgk.fsf@frigg.knielsen-hq.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 03-09-12 10:45:15, Kristian Nielsen wrote:
> It appears that ext3 and ext4 fdatasync() does not fully sync data to
> disk. Specifically, when new data is written at the end (so that the file
> length is increased), not all of the new data is synced by fdatasync().
> 
> It looks as if the problem is when the new data fits in the last allocated
> page for the file - then ext3/4 flushes the new data page to disk, but _not_
> the new metadata with the longer file size.
  Thanks for the detailed analysis. This is indeed a genuine bug. While
fixing some fsync issues I introduced (or better didn't fix) this problem.
The culprit is that we forget to update i_datasync_tid when we change only
inode size. Thus inode is not forced to disk during fdatasync(). I will send
fixes for this in a moment.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
