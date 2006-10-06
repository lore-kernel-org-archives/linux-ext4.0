From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Fri, 06 Oct 2006 14:34:59 +0400
Message-ID: <m3fye1ivfw.fsf@bzzz.home.net>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005205526.7fe744f5.akpm@osdl.org>
	<20061005205829.f6a5b031.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Alexandre Ratchov <alexandre.ratchov@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:48600 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1751427AbWJFKdv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 06:33:51 -0400
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20061005205829.f6a5b031.akpm@osdl.org> (Andrew Morton's message of "Thu, 5 Oct 2006 20:58:29 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Andrew Morton (AM) writes:

 AM> On Thu, 5 Oct 2006 20:55:26 -0700
 AM> Andrew Morton <akpm@osdl.org> wrote:

 >> You grab Alexandre's kit from http://www.bullopensource.org/ext4/20060926/
 >> and a plain old `mke2fs -j' gives a filesystem which will mount as ext3 or
 >> ext4.
 >> 
 >> If you then mount this filesystem with `-t ext4dev -o extents', it becomes
 >> incompatible with the ext3 driver.  Yes?

 AM> `mke2fs -O extents' doesn't work.  Should it?

I believe we keep extents as a mount option for a while, just
for development purposes. though there is an agreement about
mke2fs -O extents, IIRC.

thanks, Alex
