From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] ext4: Change all super.c messages to print the device
Date: Thu, 4 Jun 2009 20:17:56 +0200
Message-ID: <20090604181756.GF1065@one.firstfloor.org>
References: <4A1476D1.9080206@redhat.com> <20090604180415.GC13639@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:49583 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZFDSKh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 14:10:37 -0400
Content-Disposition: inline
In-Reply-To: <20090604180415.GC13639@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 04, 2009 at 02:04:15PM -0400, Theodore Tso wrote:
> On Wed, May 20, 2009 at 04:32:01PM -0500, Eric Sandeen wrote:
> > Do the same for ext4 as Andi did for ext3:
> > 
> > "This patch changes ext4 super.c to include the device name with all 
> > warning/error messages, by using a new utility function ext4_msg. 
> > It's a rather large patch, but very mechanic. I left debug printks
> > alone."
> 
> I've added this to the ext4 patch queue.

And how about the ext3 patch?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
