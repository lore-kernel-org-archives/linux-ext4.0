From: Alex Tomas <alex@clusterfs.com>
Subject: Re: booked-page-flag.patch
Date: Thu, 15 Feb 2007 17:03:45 +0300
Message-ID: <m3odnv4iwu.fsf@bzzz.home.net>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, Alex Tomas <alex@clusterfs.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.245.246] ([80.71.245.246]:55718 "EHLO nsold.rialcom.ru"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161318AbXBOVLR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 16:11:17 -0500
In-Reply-To: <20070215004504.023a90f0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu\, 15 Feb 2007 00\:45\:04 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Andrew Morton (AM) writes:

 AM> Sorry, we're seriously, seriously, seriously short on flags in the page
 AM> struct and this patch is going to need one heck of a good case for it to be
 AM> acceptable.

 AM> Even then, we should put a lot of effort into finding some way of avoiding
 AM> adding that page flag.  One option might be to add a new radix-tree tag,
 AM> and defining it as "for filesytem usage".  Or use PG_checked (which should
 AM> be renamed to to PG_fs_misc) (if that doesn't conflict with ext4's existing
 AM> use of PG_checked).  Or use !PageMappedToDisk()?

there is a difference between being mapped and "booked".
the latter means that page isn't allocated yet, but
space is reserved (including metadata) and we're sure
we'll be able to allocate space when the page is being
flushed.

 AM> These patches seem to have a number of issues - we should get them properly
 AM> commented and properly changelogged then get them on the wire for decent
 AM> review before investing too much in them, please.

I've been reworking the delayed allocation patch to move
part of it into VFS. I'll try to comment things better
this time.

thanks, Alex
