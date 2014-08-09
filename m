From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsck readahead speedup performance report
Date: Fri, 8 Aug 2014 23:56:46 -0400
Message-ID: <20140809035646.GA23604@thunk.org>
References: <20140809031845.GJ11191@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51933 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaHID4v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Aug 2014 23:56:51 -0400
Content-Disposition: inline
In-Reply-To: <20140809031845.GJ11191@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Interesting results!

I noticed that the 1TB SSD did seem to suffer when you went from
multi-threaded to single-threaded.  Was this a SATA-attached or
USB-attached SSD?  And any insights about why the SSD seemed to
require threading for better performance when using readaead?

						- Ted
