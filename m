From: Andrew Morton <akpm@linux-foundation.org>
Subject: booked-page-flag.patch
Date: Thu, 15 Feb 2007 00:45:04 -0800
Message-ID: <20070215004504.023a90f0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39814 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965331AbXBOIpk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 03:45:40 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Sorry, we're seriously, seriously, seriously short on flags in the page
struct and this patch is going to need one heck of a good case for it to be
acceptable.

Even then, we should put a lot of effort into finding some way of avoiding
adding that page flag.  One option might be to add a new radix-tree tag,
and defining it as "for filesytem usage".  Or use PG_checked (which should
be renamed to to PG_fs_misc) (if that doesn't conflict with ext4's existing
use of PG_checked).  Or use !PageMappedToDisk()?

These patches seem to have a number of issues - we should get them properly
commented and properly changelogged then get them on the wire for decent
review before investing too much in them, please.
