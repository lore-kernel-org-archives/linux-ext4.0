From: Larry McVoy <lm@bitmover.com>
Subject: Re: [Jfs-discussion] benchmark results
Date: Sun, 10 Jan 2010 17:32:51 -0800
Message-ID: <20100111013251.GA8233@bitmover.com>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org> <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de> <20091225161453.GD32757@thunk.org> <20091225162238.GB19303@bitmover.com> <AAA45328-6BEA-465C-B999-C99D45FC56FF@shobe.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Larry McVoy <lm@bitmover.com>, tytso@mit.edu,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	Christian Kujau <lists@nerdbynature.de>,
	linux-ext4@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	reiserfs-devel@vger.kernel.org, ext-users <ext3-users@redhat.com>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Casey Allen Shobe <casey@shobe.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipcop.bitmover.com ([192.132.92.15]:60441 "EHLO
	mail.bitmover.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750909Ab0AKBcw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Jan 2010 20:32:52 -0500
Content-Disposition: inline
In-Reply-To: <AAA45328-6BEA-465C-B999-C99D45FC56FF@shobe.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 10, 2010 at 08:03:04PM -0500, Casey Allen Shobe wrote:
> On Dec 25, 2009, at 11:22 AM, Larry McVoy wrote:
>> Dudes, sync() doesn't flush the fs cache, you have to unmount for  
>> that.
>> Once upon a time Linux had an ioctl() to flush the fs buffers, I used
>> it in lmbench.
>
>
> You do not need to unmount - 2.6.16+ have a mechanism in /proc to flush 
> caches.  See http://linux-mm.org/Drop_Caches

Cool, but I tend to come at problems from a cross platform point of view.
Aix no hable /proc :)
-- 
---
Larry McVoy                lm at bitmover.com           http://www.bitkeeper.com
