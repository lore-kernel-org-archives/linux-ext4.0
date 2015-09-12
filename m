From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck discrepancy with debugfs stat ?
Date: Fri, 11 Sep 2015 22:09:12 -0400
Message-ID: <20150912020912.GA3917@thunk.org>
References: <55F2449D.9090000@yale.edu>
 <20150911175551.GD31723@thunk.org>
 <55F332B6.3010107@yale.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Chris Hunter <chris.hunter@yale.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47154 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbbILCJR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2015 22:09:17 -0400
Content-Disposition: inline
In-Reply-To: <55F332B6.3010107@yale.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 11, 2015 at 03:59:50PM -0400, Chris Hunter wrote:
> Hi Theodore, Thanks for the reply.
> 
> Most of the e2fsck errors appear to have been uncommitted journal
> transactions. After stopping filesystem activity (hopefully to clear
> journal) a second dry-run e2fsck produced a much shorter list of errors.

Oh, if you trying to run e2fsck on a mounted file system ---- don't do
that.  The results will be very confusing.

> FYI, There was an entry "Links: 1  Blockcount: 8" reported by debugfs "stat"
> command is that same as i_links_count field ?

Yes.

						- Ted
