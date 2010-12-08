From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsck: journal-replay-only
Date: Wed, 8 Dec 2010 13:52:53 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1012081350300.3034@dhcp-lab-213.englab.brq.redhat.com>
References: <201011130009.08641.bs_lists@aakef.fastmail.fm> <20101206222714.GB24607@thunk.org> <4CFE54FF.8000600@fastmail.fm> <20101207155939.GE24607@thunk.org> <4CFF4E9C.701@fastmail.fm> <A4569757-8D33-4F23-97D7-DF4B0B62CC55@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0LHMxH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Dec 2010 07:53:07 -0500
In-Reply-To: <A4569757-8D33-4F23-97D7-DF4B0B62CC55@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 8 Dec 2010, Theodore Tso wrote:

> 
> On Dec 8, 2010, at 4:23 AM, Bernd Schubert wrote:
> 
> > Hmm, still nothing. I poked a bit around in
> > http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/ and also don't see
> > any recently updated files there.
> 
> Are you checking the master or maint branch?   I will be merging the maint branch into master, but I haven't yet since I'm doing some final patch pulls and testing before I cut 1.41.13.
> 
> -- Ted

Hi Ted,

I have the same problem, what git mirror are you using ? I am used to
checkout this one:

http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=summary

but the latest changes there are from two months ago (even the maint
branch) so I am a bit confused.

Thanks!

-Lukas

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
