From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] JBD2: round commit timer up to avoid uncommitted
	transaction
Date: Mon, 10 Aug 2009 22:52:50 -0400
Message-ID: <20090811025250.GK1756@mit.edu>
References: <20090727202209.GU4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Alex Zhuravlev <Alex.Zhuravlev@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49837 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbZHKNCl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2009 09:02:41 -0400
Content-Disposition: inline
In-Reply-To: <20090727202209.GU4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 27, 2009 at 02:22:09PM -0600, Andreas Dilger wrote:
> jbd and jbd2 fixes: fix jiffie rounding in jbd commit timer setup code.
> Rounding down could cause the timer to be fired before the corresponding
> transaction has expired.  That transaction can stay not committed forever if
> no new transaction is created or expicit sync/umount happens.
> 
> Signed-off-by: Alex Zhuravlev (Tomas) <alex.zhuravlev@sun.com>
> Signed-off-by: Andreas Dilger <adilger@sun.com>

Added to the ext4 patch queue; apologies for the delay.

      	     	  	       		     - Ted
