From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] compile fix for debuging delalloc patch
Date: Mon, 10 Aug 2009 23:13:50 -0400
Message-ID: <20090811031350.GL1756@mit.edu>
References: <1249923090.27687.4.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49839 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbZHKNCp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2009 09:02:45 -0400
Content-Disposition: inline
In-Reply-To: <1249923090.27687.4.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 10, 2009 at 09:51:30AM -0700, Mingming wrote:
> Fix compile errors when compiling ext4 patch queue unstable series..
> Need to include smp_lock.h to able to add lock_kernel() call in ioctl.c

Thanks, I've fixed up the delalloc-debug-ioctl patch.

						- Ted
