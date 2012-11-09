From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/8 v3] ext4: add operations on extent status tree
Date: Fri, 9 Nov 2012 10:22:55 +0800
Message-ID: <20121109022255.GA27826@gmail.com>
References: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
 <1351257825-3701-3-git-send-email-wenqing.lz@taobao.com>
 <20121108232123.GP19977@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jeff.liu@oracle.com, hughd@google.com,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	lczerner@redhat.com, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:46148 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab2KICKk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Nov 2012 21:10:40 -0500
Received: by mail-da0-f46.google.com with SMTP id n41so1445462dak.19
        for <linux-ext4@vger.kernel.org>; Thu, 08 Nov 2012 18:10:40 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121108232123.GP19977@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 08, 2012 at 06:21:23PM -0500, Theodore Ts'o wrote:
> On Fri, Oct 26, 2012 at 09:23:39PM +0800, Zheng Liu wrote:
> > + * 3. performance analysis
> > + *   --	overhead
> > + *	1. Apart from operations on a delayed extent tree, we need to
> > + *	down_write(inode->i_data_sem) in delayed write path to maintain delayed
> > + *	extent tree, this can have impact on parallel read-write and write-write
> 
> Hi Zheng,
> 
> I can fix this up, before I finalize your commit, but I just want to
> check.  I believe this comment is out of date --- we are now using a
> r/w spinlock, i_es_lock, yes?  Since we never hold the spinlock for
> very long, I would be surprised if this is going to be a scalability
> bottleneck (too bad Eric doesn't have access to the big SMP machine
> that he used to use to help us do our scalability testing, so we could
> check to be sure).

Hi Ted,

Oops, it is my fault.  Indeed it needs to be replaced with i_es_lock.  I
can do some tests in a server which has 16 cores, but I am afraid that
it is not so big as you thought.  I am willing to run Eric's tests to 
ensure that there is no any scalability problem.
 
Regards,
Zheng
