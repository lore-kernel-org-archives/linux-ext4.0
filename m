From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 errors on kernel 3.17.0
Date: Wed, 19 Nov 2014 08:50:59 -0500
Message-ID: <20141119135059.GA7131@thunk.org>
References: <54663355.2080903@gmail.com>
 <546C968C.60908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Angelo Dureghello <angelo70@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38912 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbaKSNvE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Nov 2014 08:51:04 -0500
Content-Disposition: inline
In-Reply-To: <546C968C.60908@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The I/O errors, the "automount: inserted" message, the fact that it
shows up on ext3 and ext4, makes it smell very much like a hardware
problem (or possibly a mmc device driver problem).  It could be caused
by a fake mmc card that (if you bought it from a street vendor or some
the micro center discount bin at the checkout counter, try getting a
brand name flash from a reputable source --- you get what you pay
for).

It could be caused by flaky hardware, or a MMC drive; it could be
caused by an MMC driver problem.  It doesn't seem like it's a file
system problem.

Regards,

						- Ted
