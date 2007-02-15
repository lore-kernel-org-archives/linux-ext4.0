From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: booked-page-flag.patch
Date: Thu, 15 Feb 2007 09:18:34 -0800
Message-ID: <45D495EA.3060200@redhat.com>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, Alex Tomas <alex@clusterfs.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030317AbXBORTM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 12:19:12 -0500
In-Reply-To: <20070215004504.023a90f0.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton wrote:
> Sorry, we're seriously, seriously, seriously short on flags in the page
> struct and this patch is going to need one heck of a good case for it to be
> acceptable.

This was for the delayed allocation patchset, right; and by managing 
this at the page level that means we can't do this for block size < page 
size, I think...

There are already buffer head flags for delalloc (block to be allocated 
  on flush) and unwritten (actual block allocated to a file but not yet 
written) in the vfs - shouldn't we be looking at using those?

Unless there is a clear path from this patchset to one that supports 
blocks < page, I'm hesitant about it... but I know I'm being a bit of an 
armchair quarterback here, and I'll try to set aside some time to give 
this a better look.

Thanks,
-Eric
