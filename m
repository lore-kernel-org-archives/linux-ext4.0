From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsck not fixing all corruptions on the first run?
Date: Thu, 13 Mar 2008 16:54:26 -0400
Message-ID: <20080313205426.GD28728@mit.edu>
References: <alpine.DEB.1.00.0803131923420.7433@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58610 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753112AbYCMUyi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 16:54:38 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803131923420.7433@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2008 at 07:34:40PM +0100, Christian Kujau wrote:
> e2fsck indeed does find a few corruptions, fixes them. The next run, e2fsck 
> says "clean" of course. But when I ran with -f, e2fsck did find more 
> (small) corruptions, see the full log here:
>
> http://nerdbynature.de/bits/e2fsprogs.pu/md4.log
> http://nerdbynature.de/bits/e2fsprogs.pu/

Hmm.  What I really need is *first* e2fsck run, to see what it did.

> Q: How comes e2fsck would skip a few things during the first run? If it
>    (technically) has to, couldn't it NOT mark the fs clean so that one
>    knows it has to run fsck again?

It's supposed to fix everything in one run.  If it doesn't, it's a
bug.  It usually means that either it attempted to fix a corruption,
and didn't fix it correctly, or some corruption confused it enough
that it didn't spot another corruption in the same run.

But as a result, that's why it's most useful to know what it found and
fixed in the first e2fsck run.  Seeing both e2fsck logs is most useful
when trying to determine why it wasn't able to fix everything in one
go.

						- Ted
