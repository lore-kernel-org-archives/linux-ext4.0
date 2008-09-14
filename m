From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Review of
	ext4-online-defrag-check-for-freespace-fragmentation.patch
Date: Sat, 13 Sep 2008 22:10:24 -0400
Message-ID: <20080914021024.GB30537@mit.edu>
References: <E1KedQ2-0004sG-Py@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org
To: a-fujita@rs.jp.nec.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47046 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137AbYINCKb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Sep 2008 22:10:31 -0400
Content-Disposition: inline
In-Reply-To: <E1KedQ2-0004sG-Py@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2008 at 06:16:42PM -0400, Theodore Ts'o wrote:
> 
> Secondly, some of the ioctl numbers chosen by the defrag patches overlap
> other, already existing patches.  This is something we will need to fix,
> long term.  For now, folks should know that we can't count on the ioctl
> numbers being stable, since we will probably need to move them.

Note: I have done this in the version of the defrag patches in the
ext4 patch queue, where all of the ioctl's introduced by the defrag
patches have been renumbered starting at 15, to avoid conflicts with
other ioctls that either exist already or could be introduced in the
future.

If you don't mind, we can also merge up some of the patches that have
been inserted in the patch queue, and then you can start working from
the modified version in the patch queue.  The other way to move
forward is that we can start creating new ioctl's that are more
general and have carefully designed interfaces, and then as the
replacement ioctl's are created, the defrag patches can be shortened
and the on-line defrag command modified to use the new ioctl's.

						- Ted
