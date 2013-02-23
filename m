From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4 xfstest regression due to ext4_es_lookup_extent
Date: Sat, 23 Feb 2013 13:37:06 +0400
Message-ID: <87txp3cqwt.fsf@openvz.org>
References: <87obfcs1x6.fsf@openvz.org> <20130222180325.GB21264@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:55675 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab3BWJhL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Feb 2013 04:37:11 -0500
Received: by mail-la0-f45.google.com with SMTP id er20so1364709lab.32
        for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2013 01:37:10 -0800 (PST)
In-Reply-To: <20130222180325.GB21264@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 22 Feb 2013 13:03:25 -0500, "Theodore Ts'o" <tytso@mit.edu> wrote:
> On Fri, Feb 22, 2013 at 09:17:57PM +0400, Dmitry Monakhov wrote:
> > 
> > 301'th xfstests are failed due to :
> > commit d100eef2440fea13e4f09e88b1c8bcbca64beb9f
> > Author: Zheng Liu <wenqing.lz@taobao.com>
> > Date:   Mon Feb 18 00:29:59 2013 -0500
> > 
> >     ext4: lookup block mapping in extent status tree
> > 
> > TESTCASE: https://github.com/dmonakhov/xfstests/commit/7b7efeee30a41109201e2040034e71db9b66ddc0
> 
> Thanks for the heads up.  I haven't updatied the xfstests I've been
> using yet, since I want to make sure I'm comparing apples and oranges
> during the merge window when I'm checking for regressions; I'll update
> my xfstests in a week or two after the merge window settles down, and
> then I'll rerun my baseline tests using the updated xfstests against
> 3.8.0 and 3.9-rc2 or 3.9-rc3.
> 
> (And furthermore, these new xfstests aren't yet in xfstests upstream
> yet, right?  Any comments from the xfstests maintainer about whether
> they are going to be willing to take your proposed new test cases?)
I hope so. I think i've fixed things according to Dave's commit.
> So when you say this is a regression, I take it that this test #301
> doesn't fail on commit d100eef2440f^, but it does fail on d100eef2440f,
> correct?
Correct. d100ee is the first bad commit which trigger BUGON()
But issue was introduced earlier  es_cache was not updated
after extents was swapped between inodes.
I'll prepare patch soon.
Actually I think that the regression in 269'th you have found recently
caused by similar issue and commit which you foud by bisecting ( the one
which allow migration between indirect<->extent based inodes)
simply helps to spot real issue in es_caching code.

BUT my main idea is that we need robust self-testing infrastructure
similar one that we have at the time extents was introduced to ext4. 
> 
> 						- Ted
