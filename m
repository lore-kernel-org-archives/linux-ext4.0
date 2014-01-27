From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How many files to create in one directory?
Date: Mon, 27 Jan 2014 14:39:50 -0500
Message-ID: <20140127193950.GA20411@thunk.org>
References: <52E607B1.2060206@jprs.co.jp>
 <52E69F3F.2000104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Masato Minda <minmin@jprs.co.jp>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51939 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbaA0Tj4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jan 2014 14:39:56 -0500
Content-Disposition: inline
In-Reply-To: <52E69F3F.2000104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> It will depend on the length of the filenames.  But by my calculations,
> for average 28-char filenames, it's closer to 30 million.

Note that there will be some very significant performance problems
well before a directory gets that big.  For example, just simply doing
a readdir + stat on all of the files in that directory (or a readdir +
unlink, etc.) will very likely result in extremely unacceptable
performance.

So if you can find some other way of avoiding allowing the file system
that big (i.e., using a real database instead of trying to use a file
system as a database, etc.), I'd strongly suggest that you consider
those alternatives.

Regards,

					- Ted
