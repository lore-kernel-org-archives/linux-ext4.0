From: Karel Zak <kzak@redhat.com>
Subject: Re: nolazytime remount
Date: Mon, 24 Aug 2015 11:29:00 +0200
Message-ID: <20150824092900.GN1689@ws.net.home>
References: <20150819082144.GB1689@ws.net.home>
 <20150819141516.GD8806@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933605AbbHXJ3D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2015 05:29:03 -0400
Content-Disposition: inline
In-Reply-To: <20150819141516.GD8806@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 19, 2015 at 02:15:16PM +0000, tytso@mit.edu wrote:
> I *think* the number of people who would want to disable lazytime is
> smaller, which why I made the decision that I did, so my thinking was
> to leave it this way until the next version of Debian stable ships,
> and then change the kernel to allow the newer versions of mount to
> disable lazytime at that point.

Yes, I think the long term solution is to support MS_LAZYTIME flags
only and remove "[no]lazytime" strings from ext4 mount options parser.

> I suppose I could set up make this be switchable, so people could
> specify ext4.support_older_mount=1 on the boot command-line option,
> but this seems really ugly, and then people would need to remember to
> remove said ugly command-line option from their grub config file when
> they update to a newer mount command.

It seems like over-engineering to introduce another comman-line option
to fix the current mount option. It would be better to keep it simple
and stupid :-)

If you want to make it configurable than use #ifdef and kconfig --
then distros like Debian may enable the obsolete string-based
"lazytime".

I don't think we have to support all permutation without kernel
recompilation, the important is to support generic use-cases and allow
to distros to compose and distribute consistent stuff. The current
situation when you have new kernel, new mount(8), but you cannot
"-o remount,nolazytime" is bad.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
