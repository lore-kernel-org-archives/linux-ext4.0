From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: booked-page-flag.patch
Date: Thu, 15 Feb 2007 12:21:04 -0800
Message-ID: <20070215122104.9c1f249b.akpm@linux-foundation.org>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
	<45D495EA.3060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, Alex Tomas <alex@clusterfs.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32972 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161163AbXBOUVp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 15:21:45 -0500
In-Reply-To: <45D495EA.3060200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 15 Feb 2007 09:18:34 -0800 Eric Sandeen <sandeen@redhat.com> wrote:

> Andrew Morton wrote:
> > Sorry, we're seriously, seriously, seriously short on flags in the page
> > struct and this patch is going to need one heck of a good case for it to be
> > acceptable.
> 
> This was for the delayed allocation patchset, right; and by managing 
> this at the page level that means we can't do this for block size < page 
> size, I think...

If the page is partially mapped to disk then we can still reserve an entire
page's worth of blocks, as long as we unreserve an entire page's worth
once the page gets fully mapped to disk.

> There are already buffer head flags for delalloc (block to be allocated 
>   on flush) and unwritten (actual block allocated to a file but not yet 
> written) in the vfs - shouldn't we be looking at using those?

We could, but we have this no-buffer-head mode which really should be the
preferred method, for 4k pagesize systems, at least.
