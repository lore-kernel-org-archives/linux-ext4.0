From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH updated] ext4: Add percpu dirty block accounting.
Date: Fri, 10 Oct 2008 19:50:57 -0400
Message-ID: <20081010235057.GH8645@mit.edu>
References: <1223633805-6172-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36793 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753537AbYJJXvI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 19:51:08 -0400
Content-Disposition: inline
In-Reply-To: <1223633805-6172-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 10, 2008 at 03:46:45PM +0530, Aneesh Kumar K.V wrote:
> This patch adds dirty block accounting using percpu_counters.  Delayed
> allocation block reservation is now done by updating dirty block
> counter.  In the later patch we switch to non delalloc mode if the
> filesystem free blocks is greater than 150% of total filesystem dirty
> blocks

Thanks, applied.

						- Ted
