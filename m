From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Fri, 28 Sep 2012 23:07:59 -0400
Message-ID: <20120929030759.GA12136@thunk.org>
References: <20120919190541.GE28470@thunk.org>
 <20120925124252.GA1518@gmail.com>
 <20120925205921.GA8625@thunk.org>
 <20120926020955.GA4101@gmail.com>
 <20120926024745.GA11468@thunk.org>
 <20120926032426.GA496@gmail.com>
 <20120926033740.GC11468@thunk.org>
 <20120928072714.GA8544@gmail.com>
 <20120928174233.GB887@thunk.org>
 <CANWLp02F=qDXY_KbhAziPkBe8qGKV6oN3XtSdc5bWOkbDG684g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52928 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab2I2DII (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Sep 2012 23:08:08 -0400
Content-Disposition: inline
In-Reply-To: <CANWLp02F=qDXY_KbhAziPkBe8qGKV6oN3XtSdc5bWOkbDG684g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 29, 2012 at 08:54:47AM +0800, Zheng Liu wrote:
> 
> When I try to fix the bigalloc bug, some code that operates on extent
> status tree and  maintains its status are changed when I do some changes in
> ext4_find_delalloc_range().  So that quite has a lot of changes I thought
> in the whole patch series.  So I think that we'd better drop this patch set
> from dev branch.  Thanks.

OK, dropped.

					- Ted
