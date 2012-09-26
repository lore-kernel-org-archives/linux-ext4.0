From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Tue, 25 Sep 2012 23:46:37 -0400
Message-ID: <20120926034637.GF11468@thunk.org>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
 <20120919190541.GE28470@thunk.org>
 <20120925124252.GA1518@gmail.com>
 <20120925205921.GA8625@thunk.org>
 <20120926020955.GA4101@gmail.com>
 <20120926024745.GA11468@thunk.org>
 <20120926032426.GA496@gmail.com>
 <20120926033740.GC11468@thunk.org>
 <20120926035448.GA14544@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52394 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab2IZDql (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2012 23:46:41 -0400
Content-Disposition: inline
In-Reply-To: <20120926035448.GA14544@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 26, 2012 at 11:54:48AM +0800, Zheng Liu wrote:
> 
> Before this weekend, I can finish a new patch set with (1) adding a sanity
> check and (2) fixing bigalloc bug.  For adding a new lock, it is
> unstable now.  So this lock will not be included in this patch set.

That sounds good to me.  Adding a rw lock is something we can do in a
separate patch (which might not make the merge window for 3.7,
depending on when Linus decides to release 3.6, but that's OK).

					- Ted
