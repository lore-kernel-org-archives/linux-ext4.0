From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [BUG?] memory hotplug: include/linux/radix-tree.h:145 invoked
 rcu_dereference_check() without protection!
Date: Wed, 8 Dec 2010 10:19:47 +0900
Message-ID: <20101208101947.b0646226.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101121112611.GB4267@deepthought.bhanu.net>
	<20101121133024.GF23423@thunk.org>
	<20101121133024.GF23423@thunk.org>
	<20101121153949.GD20947@barrios-desktop>
	<20101121173726.GG23423@thunk.org>
	<AANLkTimeSWWo-TAJPPH81OO_h1zFzWAT1Gg=XSLyFftH@mail.gmail.com>
	<rcu-radix-tree@mdm.bga.com>
	<20101122061619.GA2764@linux.vnet.ibm.com>
	<1291748509.19276.62.camel@thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: paulmck@linux.vnet.ibm.com, Milton Miller <miltonm@bga.com>,
	Minchan Kim <minchan.kim@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
	linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
	Arun Bhanu <ab@arunbhanu.com>, Mel Gorman <mel@csn.ul.ie>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
To: gerald.schaefer@de.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47992 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661Ab0LHBZm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 20:25:42 -0500
In-Reply-To: <1291748509.19276.62.camel@thinkpad>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 07 Dec 2010 20:01:49 +0100
Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> I got the same warning as reported by Arun Bhanu in "[BUG?] [Ext4] INFO:
> suspicious rcu_dereference_check() usage" during memory hotplug test on
> 2.6.37-rc5, see below.
> 
> migrate_pages() -> unmap_and_move() only calls rcu_read_lock() for anonymous
> pages, as introduced by git commit 989f89c57e6361e7d16fbd9572b5da7d313b073d.
> This should be ok, as the comment suggests, so the warning is probably a
> false positive. Eventually, migrate_page_move_mapping() will call
> radix_tree_deref_slot() with tree_lock held, but w/o rcu_read_lock() for
> non-anonymous pages.
> 
> As suggested by Milton before, a new version of radix_tree_deref_slot that
> uses rcu_dereference_protected could help, if this is a false positive, or
> maybe the rcu_read_lock() should be called for all pages, not just anonymous.
> Any thoughts?
> 

Hmm, in radix_tree_deref_slot() comment,

 140  * For use with radix_tree_lookup_slot().  Caller must hold tree at least read
 141  * locked across slot lookup and dereference.  More likely, will be used with
 142  * radix_tree_replace_slot(), as well, so caller will hold tree write locked.

racy update must not happen. rcu_dereference_protected() sounds nice.

Thanks,
-Kame

