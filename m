From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem checker)
Date: Mon, 21 Apr 2008 01:30:08 +0200
Message-ID: <87iqyc85q7.fsf@basil.nowhere.org>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
	<20080419012952.GE25797@mit.edu>
	<f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com>
	<20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com>
	<20080419220432.GB30449@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:40542 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYDTXaZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Apr 2008 19:30:25 -0400
In-Reply-To: <20080419220432.GB30449@mit.edu> (Theodore Tso's message of "Sat, 19 Apr 2008 18:04:32 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> That would be great, although I think the major issue is not
> necessarily the performance problems of using an LVM snapshot on a
> very busy filesystem (althouh I could imagine for some users this
> might be an issue), but rather for filesystem devices that aren't
> using LVM at all.  (I've heard some complaints that LVM imposes a
> performance penalty even if you aren't using a snapshot; has anyone

It always disables barriers if you don't apply a so far unmerged patch
that enables them in some special circumstances (only single
backing device) 

Not having barriers sometimes makes your workloads faster (and less
safe) and in other cases slower.

-Andi
