From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/8 v3] ext4: add operations on extent status tree
Date: Thu, 8 Nov 2012 18:21:23 -0500
Message-ID: <20121108232123.GP19977@thunk.org>
References: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
 <1351257825-3701-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jeff.liu@oracle.com, hughd@google.com,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	lczerner@redhat.com, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60144 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab2KHXVg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 18:21:36 -0500
Content-Disposition: inline
In-Reply-To: <1351257825-3701-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 26, 2012 at 09:23:39PM +0800, Zheng Liu wrote:
> + * 3. performance analysis
> + *   --	overhead
> + *	1. Apart from operations on a delayed extent tree, we need to
> + *	down_write(inode->i_data_sem) in delayed write path to maintain delayed
> + *	extent tree, this can have impact on parallel read-write and write-write

Hi Zheng,

I can fix this up, before I finalize your commit, but I just want to
check.  I believe this comment is out of date --- we are now using a
r/w spinlock, i_es_lock, yes?  Since we never hold the spinlock for
very long, I would be surprised if this is going to be a scalability
bottleneck (too bad Eric doesn't have access to the big SMP machine
that he used to use to help us do our scalability testing, so we could
check to be sure).

    			       	     	      - Ted
