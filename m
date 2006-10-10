From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: [PATCH] Get rid of extents mount option - try 2
Date: Tue, 10 Oct 2006 13:48:18 -0500
Message-ID: <1160506098.28923.7.camel@kleikamp.austin.ibm.com>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	 <20061005205526.7fe744f5.akpm@osdl.org> <20061006122105.GA21816@thunk.org>
	 <1160169015.8658.50.camel@kleikamp.austin.ibm.com>
	 <1160169700.8658.56.camel@kleikamp.austin.ibm.com>
	 <20061006153219.d5b62ee8.akpm@osdl.org>
	 <1160176800.8658.70.camel@kleikamp.austin.ibm.com>
	 <20061007041439.GA5478@thunk.org>
	 <1160236427.14217.14.camel@kleikamp.austin.ibm.com>
	 <20061007172027.GB5478@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:6101 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751082AbWJJSsZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Oct 2006 14:48:25 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9AImLr4024223
	for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2006 14:48:21 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9AImLa4350600
	for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2006 12:48:21 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9AImLAY029758
	for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2006 12:48:21 -0600
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061007172027.GB5478@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2006-10-07 at 13:20 -0400, Theodore Tso wrote:
> On Sat, Oct 07, 2006 at 10:53:47AM -0500, Dave Kleikamp wrote:
> > I noticed we are missing Documentation/filesystems/ext4.txt.  Over the
> > weekend, I'll try to put something together with instructions on getting
> > the right version of e2fsprogs, etc.
> 
> For now just say to grab the latest from:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim

Ted,
Do you think it's possible to put a source tarball out there with the
patches applied?  It's confusing to untar the tarball only to find the
patchset.  Otherwise, we'll have to beef up the instructions a little
bit.

Thanks,
Shaggy

-- 
David Kleikamp
IBM Linux Technology Center

