From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [BUG?] [Ext4] INFO: suspicious rcu_dereference_check() usage
Date: Mon, 22 Nov 2010 00:39:49 +0900
Message-ID: <20101121153949.GD20947@barrios-desktop>
References: <20101121112611.GB4267@deepthought.bhanu.net>
 <20101121133024.GF23423@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Paul McKenney <paulmck@linux.vnet.ib
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48106 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab0KUPj5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Nov 2010 10:39:57 -0500
Content-Disposition: inline
In-Reply-To: <20101121133024.GF23423@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 21, 2010 at 08:30:24AM -0500, Ted Ts'o wrote:
> On Sun, Nov 21, 2010 at 07:26:11PM +0800, Arun Bhanu wrote:
> > I saw this in kernel log messages while testing 2.6.37-rc2. I think it
> > appeared while mounting an external hard-disk. I can't seem to
> > reproduce it.
> 
> I could be wrong but this looks like it's a bug in mm/migrate.c in
> migrate_page_move_mapping(): it is calling radix_tree_lookup_slot()
> without first taking an rcu_read_lock().
> 
> It was triggered by a memory allocation out of ext4_fill_super(),
> which then triggered a memory compaction/migration, but I don't
> believe it's otherwise related to the ext4 code.
> 
> Over to the linux-mm folks for confirmation...

I think it's no problem. 

That's because migration always holds lock_page on the file page.
So the page couldn't remove from radix. 


-- 
Kind regards,
Minchan Kim
