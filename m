From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Running fsck of huge ext4 partition takes weeks
Date: Fri, 28 Aug 2015 13:53:25 -0400
Message-ID: <20150828175325.GB10211@thunk.org>
References: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com>
 <28A25D6A-DA5A-42D2-9BFE-9F6C95B51BE7@dilger.ca>
 <CAETWcfti7NL3N96K1pEAX9ezKUrZn0QeGTwjn0qUni0u6i=Gcg@mail.gmail.com>
 <CAETWcfvtjF6bh_V64LgJ1QCyW=OKjzvV+HT5zFTThS574rWfgA@mail.gmail.com>
 <20150827190548.GC3357@thunk.org>
 <CAETWcftzdWdjzVQnP-rD-o0iEFLgZFQeLx++90ZyQZiaFJB0kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52868 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbbH1Rx2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2015 13:53:28 -0400
Content-Disposition: inline
In-Reply-To: <CAETWcftzdWdjzVQnP-rD-o0iEFLgZFQeLx++90ZyQZiaFJB0kw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If dumpe2fs is hanging as well, it's likely that the problem may be at
the hardware level.  You might want to check dmesg or the kernel log
to see if there are any I/O errors being reported from hard drive.
What might be happening is that when a program (such as e2fsck or
dumpe2fs) tries to read from a specific part of the hard drive, the
hard drive is retrying a large number of times because the hard drive
head or platter surface has gotten damaged in some way.

It might also be a good idea to check the S.M.A.R.T. status using the
smartctl program.

Cheers,

						- Ted
