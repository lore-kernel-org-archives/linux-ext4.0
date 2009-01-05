From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Mon, 5 Jan 2009 12:02:59 -0500
Message-ID: <20090105170259.GB8939@mit.edu>
References: <4961603B.5020505@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58254 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZAERDD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 12:03:03 -0500
Content-Disposition: inline
In-Reply-To: <4961603B.5020505@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 05, 2009 at 02:19:55AM +0100, Thiemo Nagel wrote:
> I came across a null pointer dereference when mounting an intentionally  
> corrupted filesystem (cf. debug.dmesg).  In my opinion, the problem lies  
> in ext4_fill_super(), where truncation may occur on setting the integer  
> db_count, which results in too little memory being allocated for  
> sbi->s_group_desc.  The attached patch (against 2.6.28) fixes this by  
> changing the type of db_count to unsigned long.  I also took the  
> opportunity to make the check against sign extension in calculation of  
> db_count more strict, so that it now excludes cases in which db_count  
> comes out as zero.

Usigned unsigned long is almost always wrong, because it's not a fixed
size; it's 32 bits on x86_32, but 64 bits on x86_64.  In this
particular case, db_count is always going to well under 32-bits for
any legitimate filesystem.  If it isn't we need to have better checks;
it sounds like the checks we need are ones that do a better job
checking s_blocks_per_group; am I right in assuming that
s_blocks_per_group was something ridiculous and that is what caused
the overflow?

						- Ted
