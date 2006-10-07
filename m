From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH] Get rid of extents mount option - try 2
Date: Sat, 07 Oct 2006 23:45:08 +0400
Message-ID: <m3ejtjnc57.fsf@bzzz.home.net>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005205526.7fe744f5.akpm@osdl.org>
	<20061006122105.GA21816@thunk.org>
	<1160169015.8658.50.camel@kleikamp.austin.ibm.com>
	<1160169700.8658.56.camel@kleikamp.austin.ibm.com>
	<20061006153219.d5b62ee8.akpm@osdl.org>
	<1160176800.8658.70.camel@kleikamp.austin.ibm.com>
	<20061007041439.GA5478@thunk.org>
	<1160236427.14217.14.camel@kleikamp.austin.ibm.com>
	<20061007172027.GB5478@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:25064 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S932789AbWJGTnk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Oct 2006 15:43:40 -0400
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061007172027.GB5478@thunk.org> (Theodore Tso's message of "Sat, 7 Oct 2006 13:20:27 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Theodore Tso (TT) writes:

 >> Also, do we update the superblock in every transaction that creates or
 >> deletes a file?  Otherwise, how do we guarantee the count is accurate
 >> after replaying the journal?

 TT> Yes, we do.  The number of free inodes has to be kept up-to-date,
 TT> after all, so the superblock is marked dirty and as being part of the
 TT> transaction.

actually, not any more. we use group descriptors to initialize
free inodes counter at mount time.

thanks, Alex
