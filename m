From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/4] ext4/jbd2: possible filesystem corruption fixes
Date: Sat, 11 Oct 2008 00:25:19 -0400
Message-ID: <20081011042519.GB8145@mit.edu>
References: <48EF168A.4000705@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	jack@suse.cz
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52742 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750829AbYJKEZX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 00:25:23 -0400
Content-Disposition: inline
In-Reply-To: <48EF168A.4000705@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 10, 2008 at 05:47:06PM +0900, Hidehiro Kawai wrote:
> Hi,
> 
> This patch set fixes ext4 fs corruption problems caused by
> transient I/O error.  The ext3/jbd version is already in the
> current -mm.

Hidehiro-san,

Thanks for the patches.  I've added them to the ext4 patch queue.
They weren't pushed to Linus in the first set of patches, because I
haven't yet had time to examine them closely, but I am in the process
of testing them.

Regards,

						- Ted
