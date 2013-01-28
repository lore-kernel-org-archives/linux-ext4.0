From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RESEND][PATCH 2/2 v2] ext4: let us fully support punching hole
 feature in fallocate
Date: Mon, 28 Jan 2013 13:04:42 +0800
Message-ID: <20130128050442.GA12217@gmail.com>
References: <1358493381-20150-1-git-send-email-wenqing.lz@taobao.com>
 <1358493381-20150-2-git-send-email-wenqing.lz@taobao.com>
 <20130125033201.GD28908@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:42884 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3A1Eui (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jan 2013 23:50:38 -0500
Received: by mail-pa0-f47.google.com with SMTP id fa10so1280203pad.34
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jan 2013 20:50:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130125033201.GD28908@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 24, 2013 at 10:32:01PM -0500, Theodore Ts'o wrote:
> On Fri, Jan 18, 2013 at 03:16:21PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > After adding indirect punching hole feature, we need to enable it in fallocate.
> > For this purpose, some sanity checks need to be adjusted.  Currently we need to
> > check FALLOC_FL_PUNCH_HOLE flag before other sanity checks.
> 
> I've folded these two patches into one since the first patch in this
> series since there won't be any way to exercise the new code paths
> until we enable this in fallocate(), and it doesn't really change
> existing code paths.  If it did make huge changes in the normal code
> path, it might be useful to keep the two commits separate, but that's
> not the case here.
> 
> Anyway, they look good so I've checked them into my tree.  I'm
> currently kicking off a test run to make sure there aren't any
> problems except for the test 255 failure when testing w/o extents, but
> I don't really anticipate any issues.

Hi Ted,

Sorry, my apology.  I found a bug in indirect-based hole punching patch
when I tried to create a new test case in xfstest.  A patch has been
sent out.  Please look at it.

Thanks,
                                                - Zheng
