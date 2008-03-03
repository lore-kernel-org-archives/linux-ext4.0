From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ext4-mm-delalloc-ext4.patch
Date: Mon, 3 Mar 2008 13:08:23 -0800
Message-ID: <20080303130823.ed6991a8.akpm@linux-foundation.org>
References: <20080229010555.21ab9c77.akpm@linux-foundation.org>
	<1204305996.3629.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760540AbYCCVIv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Mar 2008 16:08:51 -0500
In-Reply-To: <1204305996.3629.5.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 29 Feb 2008 09:26:36 -0800
Mingming Cao <cmm@us.ibm.com> wrote:

> On Fri, 2008-02-29 at 01:05 -0800, Andrew Morton wrote:
> > generic_commit_write() is scheduled for removal in 2.6.26 and is
> > removed already from -mm.
> > 
> > Please switch to the new write_begin/write_end interface.
> 
> I have a patch for that, sent to linux-ext4 last week. I will merge it
> to the parent patch and update in ext4 patch queue.
> 
> ext4: use write_begin/write_end in delalloc instead of prepare_write()
> From: Mingming Cao <cmm@us.ibm.com>

Thanks.  But this change still isn't at
ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/,
so ext4 is still a no-build for me.

