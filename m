From: Paul Jackson <pj@sgi.com>
Subject: Re: How git affects kernel.org performance
Date: Mon, 8 Jan 2007 17:09:34 -0800
Message-ID: <20070108170934.dafc5b81.pj@sgi.com>
References: <1166297434.26330.34.camel@localhost.localdomain>
	<1166304080.13548.8.camel@nigel.suspend2.net>
	<459152B1.9040106@zytor.com>
	<1168140954.2153.1.camel@nigel.suspend2.net>
	<45A08269.4050504@zytor.com>
	<45A083F2.5000000@zytor.com>
	<Pine.LNX.4.64.0701062130260.3661@woody.osdl.org>
	<20070107085526.GR24090@1wt.eu>
	<20070107011542.3496bc76.akpm@osdl.org>
	<20070108030555.GA7289@in.ibm.com>
	<20070108125819.GA32756@thunk.org>
	<45A24A65.1070706@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, suparna@in.ibm.com, akpm@osdl.org, w@1wt.eu,
	torvalds@osdl.org, hpa@zytor.com, git@vger.kernel.org,
	nigel@nigel.suspend2.net, warthog9@kernel.org,
	randy.dunlap@oracle.com, pavel@ucw.cz,
	linux-kernel@vger.kernel.org, webmaster@kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx1-ext.sgi.com ([192.48.179.11]:48068 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857AbXAIBLw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jan 2007 20:11:52 -0500
To: Jeff Garzik <jeff@garzik.org>
In-Reply-To: <45A24A65.1070706@garzik.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jeff wrote:
> Something I just thought of:  ATA and SCSI hard disks do their own
> read-ahead.

Probably this is wishful thinking on my part, but I would have hoped
that most of the read-ahead they did was for stuff that happened to be
on the cylinder they were reading anyway.  So long as their read-ahead
doesn't cause much extra or delayed disk head motion, what does it
matter?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
