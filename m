From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v16 0/4] ext4: add project quota support
Date: Tue, 12 Jan 2016 12:45:56 -0500
Message-ID: <20160112174556.GA22719@thunk.org>
References: <1452588970-18309-1-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, jack@suse.cz,
	viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50059 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbcALRqO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2016 12:46:14 -0500
Content-Disposition: inline
In-Reply-To: <1452588970-18309-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Li,

The ext4 project quota patches are in the ext4.git tree and are
planned to be merged during this merge window.  I've already made some
changes to fix problems that were reported by zero day testting
service (when CONFIG_QUOTA was not enabled, for example).  Since
you've reported that the only changes in this patch series was to
rebase it to the 4.4 kernel, I don't plan to be taking a close look at
this version of the patches; please let me know if there were any
changes beyond just the rebasing changes.

Also, if you could take a look at the project quota patches in the
ext4.git tree, please let me know if you have changes you would like
since this is what I plan to be sending to Linus in the next few days.

Many thanks!

						- Ted
 
