From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Rework the ext4_da_writepages
Date: Thu, 31 Jul 2008 14:10:55 -0600
Message-ID: <20080731201055.GM3292@webber.adilger.int>
References: <1217525605-23000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:50547 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923AbYGaULC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 16:11:02 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6VKAwfS028305
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 13:11:00 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4V00901ZTI1F00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 31 Jul 2008 13:10:58 -0700 (PDT)
In-reply-to: <1217525605-23000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 31, 2008  23:03 +0530, Aneesh Kumar wrote:
> With the below changes we reserve credit needed to insert only one extent
> resulting from a call to single get_block. That make sure we don't take
> too much journal credits during writeout. We also don't limit the pages
> to write. That means we loop through the dirty pages building largest
> possible contiguous block request. Then we issue a single get_block request.
> We may get less block that we requested. If so we would end up not mapping
> some of the buffer_heads. That means those buffer_heads are still marked delay.
> Later in the writepage callback via __mpage_writepage we redirty those pages.

Can you please clarify this?  Does this mean we take one pass through the
dirty pages, but possibly do not allocate some subset of the pages.  Then,
at some later time these holes are written out separately?  This seems
like it would produce fragmentation if we do not work to ensure the pages
are allocated in sequence.  Maybe I'm misunderstanding your comment and
the unmapped pages are immediately mapped on the next loop?

It is great that this will potentially allocate huge amounts of space
(up to 128MB ideally) in a single call if the pages are contiguous.

The only danger I can see of having many smaller transactions instead
of a single larger one is if this is causing many more transactions
in the case of e.g. O_SYNC or similar, but AFAIK that is handled at
a higher level and we should be OK.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

