From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2] ext4: Don't use the range_cylic mode implemented
	by write_cache_pages
Date: Sat, 14 Feb 2009 10:16:17 -0500
Message-ID: <20090214151617.GH26628@mini-me.lan>
References: <1234598915-25830-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34764 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbZBNPQy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Feb 2009 10:16:54 -0500
Content-Disposition: inline
In-Reply-To: <1234598915-25830-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've rewritten the patch description for clarity's sake; can you
confirm I didn't mess anything up?

						- Ted

ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

With delayed allocation we lock the page in write_cache_pages() and
try to build an in memory extent of contiguous blocks.  This is needed
so that we can get large contiguous blocks request.  If range_cyclic
mode is enabled, write_cache_pages() will loop back to the 0 index if
no I/O has been done yet, and try to start writing from the beginning
of the range.  That causes an attempt to take the page lock of lower
index page while holding the page lock of higher index page, which can
cause a dead lock with another writeback thread.

The solution is to implement the range_cyclic behavior in
ext4_da_writepages() instead.

http://bugzilla.kernel.org/show_bug.cgi?id=12579

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
