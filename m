From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Get rid of extents mount option - try 2
Date: Fri, 6 Oct 2006 15:32:19 -0700
Message-ID: <20061006153219.d5b62ee8.akpm@osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	<20061005205526.7fe744f5.akpm@osdl.org>
	<20061006122105.GA21816@thunk.org>
	<1160169015.8658.50.camel@kleikamp.austin.ibm.com>
	<1160169700.8658.56.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:30699 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161018AbWJFWce (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 18:32:34 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <1160169700.8658.56.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 06 Oct 2006 16:21:40 -0500
Dave Kleikamp <shaggy@austin.ibm.com> wrote:

> Enabling an ext4 file system to use extents should be done with
> 'tune2fs -O extents' or 'mke2fs -O extents', not with a mount option

But the mke2fs which I built by applying
http://www.bullopensource.org/ext4/20060926/ to e2fsprogs-1.39 doesn't
recognise `-O extents'.  So the only way I can use extents is `mount -o
extents'.

What am I missing here?
