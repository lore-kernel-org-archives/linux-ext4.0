From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH v2 0/8] Filesystem io types statistic
Date: Mon, 14 Nov 2011 10:23:01 +0000
Message-ID: <1321266181.2731.8.camel@menhir>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
	 <1321008926.2710.39.camel@menhir>  <20111111153246.GA6826@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab1KNKVV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 05:21:21 -0500
In-Reply-To: <20111111153246.GA6826@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Fri, 2011-11-11 at 23:32 +0800, Zheng Liu wrote:
> On Fri, Nov 11, 2011 at 10:55:26AM +0000, Steven Whitehouse wrote:
> > Hi,
> > 
> > On Thu, 2011-11-10 at 18:34 +0800, Zheng Liu wrote:
> > > Hi all,
> > > 
> > > v1->v2: totally redesign this mechanism
> > > 
> > > This patchset implements an io types statistic mechanism for filesystem
> > > and it has been added into ext4 to let us know how the ext4 is used by
> > > applications. It is useful for us to analyze how to improve the filesystem
> > > and applications. Nowadays, I have added it into ext4, but other filesytems
> > > also can use it to count the io types by themselves.
> > > 
> > > A 'Issue' flag is added into buffer_head and will be set in submit_bh().
> > > Thus, we can check this flag in filesystem to know that a request is issued
> > > to the disk when this flag is set. Filesystems just need to check it in
> > > read operation because filesystem should know whehter a write request hits
> > > cache or not, at least in ext4. In filesystem, buffer needs to be locked in
> > > checking and clearing this flag, but it doesn't cost much overhead.
> > > 
> 
> Hi Steve,
> 
> Thank you for your attention.
> 
> > There is already a REQ_META flag available which allows distinction
> > between data and metadata I/O (at least when they are not contained
> > within the same block). If that was to be extended to allow some
> > filesystem specific bits that would solve the problem that you appear to
> > be addressing with these patches in a fs independent way.
> 
> You are right. REQ_META flag quite can distinguish between metadata and
> data. But it is difficulty to check this flag in filesystem because
> buffer_head doesn't use it and most of filesystems still use buffer_head
> to submit a IO request. This is the reason why I added a new flag into
> buffer_head.
> 
I don't understand what you mean here.... submit_bh() takes a bh and a
set of REQ flags, so there is no reason to not use REQ_META. Using a bh
doesn't prevent setting those flags. The issue is only that few bits
remain unused in those flags and solving the problem in a "nice" way, by
adding a few more flags, may be tricky.

> > 
> > That would probably have already been done, except that the REQ_ flags
> > field is already almost full - so it might need the addition of an extra
> > field or some other solution.
> 
> In v1[1], a structure called ios is defined. This structure saves some
> information (e.g. IO type) and a callback function. Some interfaces in
> buffer layer are modifed to add a new argument that points to this
> structure. When this request doesn't hit cache and is issued to the
> disk, the callback function in this structure will be called. Filesystem
> can define a function to do some operations. A defect in this solution
> is that it needs to change some interfaces, such bread, breadahead and
> so on. So in v2, I re-implement a new mechanism.
> 
> > 
> > Either way, an fs independent solution to this problem would be worth
> > considering,
> 
> Yes, I am willing to implement an fs independent solution. This is my
> original intention too. So any suggestions are welcome. Thank you.
> 
> [1] http://www.spinics.net/lists/linux-ext4/msg28608.html
> 
> Regards,
> Zheng
> 
Ok. Sounds good. GFS2 already sets REQ_META in all places where metadata
is being written. Now that REQ_META as been demerged from the REQ_PRIO
flag, there is no reason that filesystems cannot set it without fear of
side effects. Its only purpose is as a notification to blktrace now,

Steve.


