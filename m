From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] tests: use make rules to run tests in parallel (v2)
Date: Mon, 28 May 2012 17:48:53 -0600
Message-ID: <73DE6E4C-65E5-4834-B5E2-56168DC3DBFD@whamcloud.com>
References: <1337797871-19357-1-git-send-email-adilger@whamcloud.com> <1337803760-20587-1-git-send-email-adilger@whamcloud.com> <20120528011810.GA19152@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63878 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2E1Xs6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 May 2012 19:48:58 -0400
Received: by dady13 with SMTP id y13so4646001dad.19
        for <linux-ext4@vger.kernel.org>; Mon, 28 May 2012 16:48:58 -0700 (PDT)
In-Reply-To: <20120528011810.GA19152@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-27, at 7:18 PM, Ted Ts'o wrote:
> On Wed, May 23, 2012 at 02:09:20PM -0600, Andreas Dilger wrote:
>> Change the e2fsck/mke2fs/tune2fs/e2image/debugfs regression tests
>> to be driven by Makefile rules instead of by a script loop.  This
>> allows the tests to be run in parallel like a build and reduces
>> testing time significantly.
> 
> The makefile setup you've created has a fatal flaw; it completely
> blows up if you are building with VPATH.  That is, try this with your
> patch: (starting with cwd in the e2fsprogs source tree)
> 
> % mkdir build
> % cd build
> % ../configure
> % make
> % make check
>    <boom>
> 
> Could you take a look at fixing this, please?  I rely pretty
> exclusively on building with VPATH (that way I can have a
> build.static, build.32, etc.) with a single source tree.

The v3 patch was fixed to work with VPATH, along with a few other
changes that I made locally while I've been using this since its
original submission.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




