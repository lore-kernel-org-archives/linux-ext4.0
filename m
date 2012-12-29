From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 0/6] add full off-line resize2fs support for flex_bg
 file systems
Date: Sat, 29 Dec 2012 04:32:23 -0500
Message-ID: <20121229093223.GA20918@thunk.org>
References: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@horizon.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40821 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2L2Jc1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 04:32:27 -0500
Content-Disposition: inline
In-Reply-To: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In addition to people reviewing these patches, I'd really appreciate
it if some folks could try doing some testing.  These changes are
included on the pu (proposed update) branch which I've pushed out to
the e2fprogs git tree.  I've done some light testing, and so far
everything works, but it would be great if we could have more people
trying to beat up on these changes.

Thanks!!

						- Ted
