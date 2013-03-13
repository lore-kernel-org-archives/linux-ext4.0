From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: use s_extent_max_zeroout_kb value as number of
 kb
Date: Wed, 13 Mar 2013 07:53:42 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303130750530.7128@dhcp-1-104.brq.redhat.com>
References: <1363106209-1883-1-git-send-email-lczerner@redhat.com> <20130312164511.GC4959@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	wenqing.lz@taobao.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836Ab3CMGxu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 02:53:50 -0400
In-Reply-To: <20130312164511.GC4959@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 12 Mar 2013, Theodore Ts'o wrote:

> Date: Tue, 12 Mar 2013 12:45:11 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, wenqing.lz@taobao.com
> Subject: Re: [PATCH] ext4: use s_extent_max_zeroout_kb value as number of kb
> 
> Thanks, applied.
> 
> I'm on the fence about whether to submit this after -rc2 or not.
> This appears to make potential bug much rarer, and it's a trivial
> patch to backport, but it does make rather large changes in how we
> handle fragmented filesystem.  (For the better, but it's a large
> change, and it is getting rather late in the season.)
> 
> I'm going to include in the dev branch for now, and give it all a good
> instensive testing, but there may be some patches in dev that may get
> deferred to the next merge window before I send a pull request to
> Linus (probably during the coming weekend).
> 
> Folks should feel free to propose patches they think should wait for
> the next merge window.
> 
> 					- Ted

Hi Ted,

in my opinion this should go in sooner rather than later, because
even though it changes the behaviour quite significantly, it also
brings back the old (expected) behaviour which has been changed by
accident with that bug.

Anyway, I am going to run couple of more tests with that patch as
well.

Thanks!
-Lukas
