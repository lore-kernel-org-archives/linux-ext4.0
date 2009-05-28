From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] e2fsprogs - add resource track for e2fsck
Date: Thu, 28 May 2009 09:37:54 -0400
Message-ID: <20090528133754.GP26625@mit.edu>
References: <b040c32a0905042012j1483fca1o27db92082605f313@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ken Chen <kenchen@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59297 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbZE1NiD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 09:38:03 -0400
Content-Disposition: inline
In-Reply-To: <b040c32a0905042012j1483fca1o27db92082605f313@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 04, 2009 at 08:12:30PM -0700, Ken Chen wrote:
> This patch adds individual resource tracking for e2fsck's pass1[b-d] phase.
> 
> On ext2, time tracking for pass1 includes both error detection and
> specific type of fs fix-up phase (e.g. block referenced by multiple
> inodes).  The multi-reference fix-up phase some time take significant
> amount of time to complete.  We would like to track time spent in sub
> component of pass1 by having a finer granularity during pass1b through
> pass1d phase.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>

Thanks, applied.

					- Ted
