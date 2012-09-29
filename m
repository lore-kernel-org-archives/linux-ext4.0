From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Sat, 29 Sep 2012 21:26:38 +0800
Message-ID: <CANWLp031rZcVV8daVb6AxzAX3EEFo=T8ZgY2PErm=qx6khvtjg@mail.gmail.com>
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
	<20120929030759.GA12136@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120929030759.GA12136@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Sep 29, 2012 at 11:07 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Sep 29, 2012 at 08:54:47AM +0800, Zheng Liu wrote:
>>
>> When I try to fix the bigalloc bug, some code that operates on extent
>> status tree and  maintains its status are changed when I do some changes in
>> ext4_find_delalloc_range().  So that quite has a lot of changes I thought
>> in the whole patch series.  So I think that we'd better drop this patch set
>> from dev branch.  Thanks.
>
> OK, dropped.

Thank you very much.  I will add rwlock to protect this tree, and do
more tests for this patch set.

Regards,
Zheng
