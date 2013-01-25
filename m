From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext4: call WARN_ON after the debug message
Date: Fri, 25 Jan 2013 10:22:44 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1301251012200.20753@localhost>
References: <1359045044-31435-1-git-send-email-lczerner@redhat.com> <20130124195458.GD9477@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab3AYJWt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2013 04:22:49 -0500
In-Reply-To: <20130124195458.GD9477@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 24 Jan 2013, Theodore Ts'o wrote:

> Date: Thu, 24 Jan 2013 14:54:58 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 1/2] ext4: call WARN_ON after the debug message
> 
> On Thu, Jan 24, 2013 at 05:30:43PM +0100, Lukas Czerner wrote:
> > In two places we call WARN_ON() before we print out the debug message,
> > however the custom is to print such messages before we call WARN_ON() so
> > change that.
> > 
> > Also use ext4_msg() instead of plain printk().
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> I was actually thinking about removing the WARN_ON entirely, or at
> least suppressing it when the error begin returned from
> ext4_map_blocks is EIO.  The reason for that is the warning is causing
> noise for automated log scanners, and if the problem is caused by a
> hardware failure, there's no real point in dumping out a stack trace.
> More generally, is there any reason why we need the stack trace at
> all?
> 
> Also maybe we should use ext4_warning() instead of ext4_msg()?
> 
>      	      	     	 		- Ted

Hi Ted,

we can get the EIO error from ext4_map_blocks not only in the case
of hardware error. The extent tree might not be in consistent state,
or we could even ask for blocks outside the file system itself (I
believe I've seen this before) and I think that in those cases it
might be worth to all WARN_ON.

Also people from ABRT are working on kerneloops.org replacement (so
far it only works for Fedora)
https://retrace.fedoraproject.org/faf/problems/hot/ so we can notice
such problems, yes they catch even kernel WARNs because it usually
means that we have bug somewhere else.

I agree that it would be better to use ext4_warning(), so I'll
resend the patch.

Thanks!
-Lukas
