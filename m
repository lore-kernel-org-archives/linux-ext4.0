From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 3/8 v2] ext4: initialize extent status tree
Date: Fri, 28 Sep 2012 13:42:33 -0400
Message-ID: <20120928174233.GB887@thunk.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120928072714.GA8544@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 28, 2012 at 03:27:14PM +0800, Zheng Liu wrote:
> 
> Until now, I have fixed the bigalloc bug that is reported by xfstest
> #230, and merged Hugh's patch.  But I do really think that this patch
> set couldn't be applied at this merge window because the change is not
> *minor*, and it still needs to do more tests.  That would be great if
> you can keep this patch set in dev branch at this merge window.  Thanks!

The dev branch is the set of patches that are planned to go to Linus
during the next merge window, so if we drop it from the merge window,
I would drop it from the dev branch and put it in the "unstable"
portion of the patch series.

It would be a shame to drop it since this provides the SEEK_HOLE
capability, though.  Can you say more about which change is not minor?
The change to fix the bigalloc bug?   Or the whole patch series?

					- Ted
