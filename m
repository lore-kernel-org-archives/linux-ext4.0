From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 01/11] rbtree: Fix
 rbtree_postorder_for_each_entry_safe() iterator
Date: Thu, 7 Nov 2013 13:38:00 -0800
Message-ID: <20131107133800.c779b2f2b2ec73c91cd25f47@linux-foundation.org>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
	<1383788572-25938-2-git-send-email-cody@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Seth Jennings <sjenning@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3KGViC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Nov 2013 16:38:02 -0500
In-Reply-To: <1383788572-25938-2-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed,  6 Nov 2013 17:42:30 -0800 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:

> The iterator rbtree_postorder_for_each_entry_safe() relies on pointer
> underflow behavior when testing for loop termination. In particular
> it expects that
>   &rb_entry(NULL, type, field)->field
> is NULL. But the result of this expression is not defined by a C standard
> and some gcc versions (e.g. 4.3.4) assume the above expression can never
> be equal to NULL. The net result is an oops because the iteration is not
> properly terminated.
> 
> Fix the problem by modifying the iterator to avoid pointer underflows.

So the sole caller is in zswap.c.  Is that code actually generating oopses?

IOW, is there any need to fix this in 3.12 or earlier?
