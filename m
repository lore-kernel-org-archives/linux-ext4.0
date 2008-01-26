From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 24/49] ext4: add block bitmap validation
Date: Sat, 26 Jan 2008 08:26:04 -0500
Message-ID: <20080126132604.GB8348@mit.edu>
References: <1200970948-17903-17-git-send-email-tytso@mit.edu> <1200970948-17903-18-git-send-email-tytso@mit.edu> <1200970948-17903-19-git-send-email-tytso@mit.edu> <1200970948-17903-20-git-send-email-tytso@mit.edu> <1200970948-17903-21-git-send-email-tytso@mit.edu> <1200970948-17903-22-git-send-email-tytso@mit.edu> <1200970948-17903-23-git-send-email-tytso@mit.edu> <1200970948-17903-24-git-send-email-tytso@mit.edu> <1200970948-17903-25-git-send-email-tytso@mit.edu> <20080123140654.fe8c658e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51485 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149AbYAZN0P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2008 08:26:15 -0500
Content-Disposition: inline
In-Reply-To: <20080123140654.fe8c658e.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 23, 2008 at 02:06:54PM -0800, Andrew Morton wrote:
> brelse() should only be used when the bh might be NULL - put_bh()
> can be used here.
> 
> Please review all ext4/jbd2 code for this trivial speedup.

I've reviewed all of the pending patches in the stable queue for this
speedup, and applied them where necessary; it was useful, since I
detected a buffer head leak in one of the patches while I was at it.

The ext4/jbd2 code as a whole still needs to be reviewed for this
speedup, but I don't want to fix this in the initial stable push, lest
I break something by accident.  I'll put it in the "TO DO" queue.

Regards,

      		   	      	       	     - Ted
