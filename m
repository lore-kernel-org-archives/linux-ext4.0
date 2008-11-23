From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V2 2/5] ext4: unlock group before ext4_error
Date: Sun, 23 Nov 2008 08:43:04 -0500
Message-ID: <20081123134304.GB26473@mit.edu>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081123133704.GA26473@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37552 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757650AbYKWNpj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2008 08:45:39 -0500
Content-Disposition: inline
In-Reply-To: <20081123133704.GA26473@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 23, 2008 at 08:37:04AM -0500, Theodore Tso wrote:
> This looks like it came from the patch
> aneesh-8-fix-double-free-of-blocks which in a message sent roughly at
> the same time you told me to drop from the patch queue.  So I'm adding
> this to the patch queue without this rejected hunk.

Sorry, I managed to confuse myself.  The patch conflict went away
after I removed the patch per your e-mail.  I have so many *.rej files
in my tree from failed patches that I managed to confuse myself.  I'll
have to clean them out....

My comments about how difficult it is to figure out where your patches
apply are still relevant......  I'm still trying to figure this all
out, but you'll need to check the patch queue afterwards.  Can you
please give me a status readout about which patches I can move into
the stable part of the tree, please?  And what the status is of the
other patches?  Thanks!!!

							- Ted
