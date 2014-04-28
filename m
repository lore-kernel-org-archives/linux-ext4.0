From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] resize2fs: fix overly-pessimistic calculation of minimum size required
Date: Mon, 28 Apr 2014 11:34:54 +0400
Message-ID: <87sioxdi01.fsf@openvz.org>
References: <1398566894-14576-1-git-send-email-tytso@mit.edu> <20140427043537.GC25172@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:64944 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaD1He6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2014 03:34:58 -0400
Received: by mail-la0-f41.google.com with SMTP id el20so2335251lab.14
        for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2014 00:34:57 -0700 (PDT)
In-Reply-To: <20140427043537.GC25172@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 27 Apr 2014 00:35:37 -0400, "Theodore Ts'o" <tytso@mit.edu> wrote:
> On Sat, Apr 26, 2014 at 10:48:14PM -0400, Theodore Ts'o wrote:
> > For extent-mapped file systems, we need to reserve some extra space in
> > case we need to grow the extent tree.  Calculate the safety margin
> > more intelligently, so we don't overestimate the amount of space
> > required.
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > Reported-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> I'm going to have to self-NACK this.  This patch causes the resize2fs
> regression tests to fail.  (In fact, Dmitry's original patch also
> causes the resize2fs regression tests to fail.)
Agree, regressions are not acceptable. Can you please spacify
which tests are failed. As far as i know xfstetsts has no tests
for resize2fs.
> The problem is kind of messy; when the file system starts at some
> insanely large size, and we shrink it very small, we end up releasing
> a lot of inode tables in the first block group (many for other block
> groups).  But until we're 100% sure the resize will be successful, we
> don't want to start overwriting those inode table blocks.
> 
> For this reason, if we try to constrain resize the file system down
> from 2TB to 512MB in one shot, we need to do this in multiple steps.
> I.e. by calling "resize2fs -M /dev/sdXX" multiple times.
> 
> There really isn't a good way around this, and in fact, if people are
> going to be doing silly things like take a file system from 16T down
> to 750MB, if they need to run resize2fs multiple times, that's fine.
> It would be nice if you could shrink the file system down in a single
> shot, but it's not high priority.
> 
> 					- Ted
