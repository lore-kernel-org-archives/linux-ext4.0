From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: ratelimit the file system mounted message
Date: Mon, 17 Aug 2015 11:12:15 +1000
Message-ID: <20150817011215.GA714@dastard>
References: <1439665197-10766-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:50132 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbbHQBNU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Aug 2015 21:13:20 -0400
Content-Disposition: inline
In-Reply-To: <1439665197-10766-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 15, 2015 at 02:59:57PM -0400, Theodore Ts'o wrote:
> The xfstests ext4/305 will mount and unmount the same file system over
> 4,000 times, and each one of these will cause a system log message.
> Ratelimit this message since if we are getting more than a few dozen
> of these messages, they probably aren't going to be helpful.

Perhaps you should look at fixing the test or making it a more
targetted reproducer. Tests that do "loop doing something basic
while looping doing something else basic for X minutes to try to
trip a race condition" aren't very good regression tests....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
