From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Fwd: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Sat, 29 Sep 2012 21:24:47 +0800
Message-ID: <CANWLp00=ja-Aymve_VGWWpecPjmSH00LA9RG8deTzXdzmuW4nA@mail.gmail.com>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
	<1345615545-26133-4-git-send-email-wenqing.lz@taobao.com>
	<20120919190541.GE28470@thunk.org>
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
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CANWLp02F=qDXY_KbhAziPkBe8qGKV6oN3XtSdc5bWOkbDG684g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[Sorry, I got an delivery error when the original mail is sent to the
mailing list.  Cc' to them]

On Saturday, September 29, 2012, Theodore Ts'o wrote:
>
> On Fri, Sep 28, 2012 at 03:27:14PM +0800, Zheng Liu wrote:
> >
> > Until now, I have fixed the bigalloc bug that is reported by xfstest
> > #230, and merged Hugh's patch.  But I do really think that this patch
> > set couldn't be applied at this merge window because the change is not
> > *minor*, and it still needs to do more tests.  That would be great if
> > you can keep this patch set in dev branch at this merge window.  Thanks!
>
> The dev branch is the set of patches that are planned to go to Linus
> during the next merge window, so if we drop it from the merge window,
> I would drop it from the dev branch and put it in the "unstable"
> portion of the patch series.
>
> It would be a shame to drop it since this provides the SEEK_HOLE
> capability, though.  Can you say more about which change is not minor?
> The change to fix the bigalloc bug?   Or the whole patch series?
>
>

Hi Ted,

When I try to fix the bigalloc bug, some code that operates on extent
status tree and  maintains its status are changed when I do some
changes in ext4_find_delalloc_range().  So that quite has a lot of
changes I thought in the whole patch series.  So I think that we'd
better drop this patch set from dev branch.  Thanks.

Regards,
Zheng
