From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: dump ext4 performance degrades linearly as disk fills
Date: Tue, 17 Jun 2014 10:51:29 -0400
Message-ID: <20140617145129.GB5054@thunk.org>
References: <539E8401.5000607@josephdwagner.info>
 <20140616124229.GA8465@thunk.org>
 <53A04BEB.7000401@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Joseph D. Wagner" <joe@josephdwagner.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43043 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973AbaFQOve (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 10:51:34 -0400
Content-Disposition: inline
In-Reply-To: <53A04BEB.7000401@josephdwagner.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hmm, I've looked at your dumpe2fs, and the free space looks pretty
good.  Was this taken before or after you ran the backup?

How big are your full and incremental backups?  And were you testing
the time when writing an incremental backup or a full backup?

Finally, can you use the debugfs program, and then use the debugfs's
"extents" commands?   i.e.

% debugfs /dev/heap/u1
debugfs: extents linux-image-3.15.0-00037-g7428869-dbg_3.15.0-00037-g7428869-86_amd64.deb
Level Entries       Logical            Physical Length Flags
 0/ 0   1/  3     0 -     9 16898520 - 16898529     10 
 0/ 0   2/  3    10 -  2047 17518592 - 17520629   2038 
 0/ 0   3/  3  2048 -  9881 17500160 - 17507993   7834 
debugfs:  q

... and send me the output?

Thanks!!

					- Ted
