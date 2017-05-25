From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: fix sparse bmap to extent conversion
Date: Wed, 24 May 2017 22:21:35 -0400
Message-ID: <20170525022135.tbzsiyd3cbvrdlto@thunk.org>
References: <20170523190019.GF4510@birch.djwong.org>
 <982fc176-2a8d-1318-8eec-2524c6af1e00@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Marc Thomas <marc@dragonfly.plus.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35632 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755139AbdEYCVl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 May 2017 22:21:41 -0400
Content-Disposition: inline
In-Reply-To: <982fc176-2a8d-1318-8eec-2524c6af1e00@dragonfly.plus.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've applied this patch to the maint branch (with a slight adjustment
to the expect file for f_convert_bmap_sprase), and then merged it into
the next/master branches (with the adjustment removed), thanks.

I wasn't able see any problems with f_detect_junk, on either the maint
or the next branch.  So I'm not sure what issue Marc was seeing there.

       	    	     	    	     	  - Ted
