From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/3]ext4: online defrag (ver 2.0)
Date: Fri, 19 Jun 2009 12:13:59 -0400
Message-ID: <20090619161359.GI31377@mit.edu>
References: <4A164EC9.3070405@rs.jp.nec.com> <87f94c370906111603l4ed1c383tf0d725cb5ac95eaf@mail.gmail.com> <200906120947.58071.andreas.philipp@uni-graz.at> <87f94c370906120631i386acb94tb1039626c765ef60@mail.gmail.com> <4A3BA67B.9020803@aipe.at> <87f94c370906190831j4e1d7146k559c272e0ff7ddad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Philipp <andreas.philipp@aipe.at>,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51024 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbZFSQOG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jun 2009 12:14:06 -0400
Content-Disposition: inline
In-Reply-To: <87f94c370906190831j4e1d7146k559c272e0ff7ddad@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 19, 2009 at 11:31:20AM -0400, Greg Freemyer wrote:
> 
> Ted also pushed them as part of the 2.6.31 merge window, so testers
> will be able to test with 2.6.30-git14 or newer without having to
> apply the patches separately..

You may need a slightly modified userspace utility from what Akira-san
posted, which you can get here:

http://repo.or.cz/w/ext4-patch-queue.git?a=blob_plain;f=online-defrag-cmd;h=7d42ad5cdb6813d262201d6806531f189d3d1f57;hb=35e9fa546ac349cb9a7c4ee9e45ff9747edd9335

This reflects a change that I made in the structure passed in the new
EXT4_IOC_MOVE_EXT ioctl.

Note that I have not done a lot of stress testing of the defrag
functionality, so please be careful using it on production systems.
Please make sure you backup your files before trying to use it.

       	    	     	    	       	      - Ted
