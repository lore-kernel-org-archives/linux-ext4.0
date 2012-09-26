From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Wed, 26 Sep 2012 11:59:30 +0800
Message-ID: <20120926035930.GA27579@gmail.com>
References: <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
 <20120919190541.GE28470@thunk.org>
 <20120925124252.GA1518@gmail.com>
 <20120925205921.GA8625@thunk.org>
 <20120926020955.GA4101@gmail.com>
 <20120926024745.GA11468@thunk.org>
 <20120926032426.GA496@gmail.com>
 <20120926033740.GC11468@thunk.org>
 <20120926035448.GA14544@gmail.com>
 <20120926034637.GF11468@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34143 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2IZDsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2012 23:48:53 -0400
Content-Disposition: inline
In-Reply-To: <20120926034637.GF11468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 25, 2012 at 11:46:37PM -0400, Theodore Ts'o wrote:
> On Wed, Sep 26, 2012 at 11:54:48AM +0800, Zheng Liu wrote:
> > 
> > Before this weekend, I can finish a new patch set with (1) adding a sanity
> > check and (2) fixing bigalloc bug.  For adding a new lock, it is
> > unstable now.  So this lock will not be included in this patch set.
> 
> That sounds good to me.  Adding a rw lock is something we can do in a
> separate patch (which might not make the merge window for 3.7,
> depending on when Linus decides to release 3.6, but that's OK).

OK, I will submit a new patch set ASAP.

Regards,
Zheng
