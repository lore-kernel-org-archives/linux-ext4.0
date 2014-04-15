From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] generic/237: fix filtering for expected failure
 message
Date: Mon, 14 Apr 2014 22:08:36 -0400
Message-ID: <20140415020836.GB21827@thunk.org>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
 <1397343317-14669-4-git-send-email-tytso@mit.edu>
 <20140414001408.GC27694@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54380 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaDOCIl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Apr 2014 22:08:41 -0400
Content-Disposition: inline
In-Reply-To: <20140414001408.GC27694@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After looking at this more closely, this patch isn't needed.  It was a
configuration screw up on my end.

					- Ted
