From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: [PATCH] Get rid of extents mount option - try 2
Date: Fri, 06 Oct 2006 18:20:00 -0500
Message-ID: <1160176800.8658.70.camel@kleikamp.austin.ibm.com>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	 <20061005205526.7fe744f5.akpm@osdl.org> <20061006122105.GA21816@thunk.org>
	 <1160169015.8658.50.camel@kleikamp.austin.ibm.com>
	 <1160169700.8658.56.camel@kleikamp.austin.ibm.com>
	 <20061006153219.d5b62ee8.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:29843 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1423000AbWJFXUE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 19:20:04 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k96NK2Q2032315
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 19:20:02 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k96NK2Hc293910
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 19:20:02 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k96NK2DN027401
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 19:20:02 -0400
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20061006153219.d5b62ee8.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2006-10-06 at 15:32 -0700, Andrew Morton wrote:
> On Fri, 06 Oct 2006 16:21:40 -0500
> Dave Kleikamp <shaggy@austin.ibm.com> wrote:
> 
> > Enabling an ext4 file system to use extents should be done with
> > 'tune2fs -O extents' or 'mke2fs -O extents', not with a mount option
> 
> But the mke2fs which I built by applying
> http://www.bullopensource.org/ext4/20060926/ to e2fsprogs-1.39 doesn't
> recognise `-O extents'.  So the only way I can use extents is `mount -o
> extents'.
> 
> What am I missing here?

To be honest, I've been lazy and I haven't even tried to get the new
e2fsprogs.  I just grabbed the latest from the mercurial repository,
http://e2fsprogs.sourceforge.net/e2fsprogs-hacking.html , and it doesn't
work for me either.  Ted?

Hold off on the patch until we figure it out.  :-)

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

