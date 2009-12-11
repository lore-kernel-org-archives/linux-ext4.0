From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH] replaced BUG() with return
	-EIO	from	ext4_ext_get_blocks
Date: Fri, 11 Dec 2009 14:16:55 -0800
Message-ID: <1260569815.21896.24.camel@bobble.smo.corp.google.com>
References: <1260540418-11844-1-git-send-email-surbhi.palande@canonical.com>
	 <1260554859.21896.8.camel@bobble.smo.corp.google.com>
	 <4B22A572.5010201@redhat.com>
	 <1260562923.21896.11.camel@bobble.smo.corp.google.com>
	 <4B22C393.2090709@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: surbhi.palande@canonical.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:8266 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761531AbZLKWRM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Dec 2009 17:17:12 -0500
In-Reply-To: <4B22C393.2090709@canonical.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2009-12-12 at 00:11 +0200, Surbhi Palande wrote:
> Hi Frank,
> 
> Frank Mayhar wrote:
> > On Fri, 2009-12-11 at 14:02 -0600, Eric Sandeen wrote:
> >   
> >> My first thought was that this was a bandaid too, but I guess it can
> >> come about due to on-disk corruption for any reason, so it should
> >> be handled gracefully, and I suppose this approach seems fine.
> >>     
> >
> > That's why we've been running with it, yes.
> >
> >   
> >> Since this is catching on-disk corruption, though, it'd be better to call
> >> ext4_error() and let the mount-time error-handling policy decide what to do.
> >>
> >> I like having more info but below seems awfully wordy ;)  Maybe the first
> >> printk would suffice, and switching it to an ext4_error() would be best,
> >> I think.
> >>     
> >
> > Okay, I'll rework the patch a bit and resubmit it.
> >   
> Since I published this patch first against a reported upstream bug, I
> will work on the comments and resubmit the patch!

Okay, go for it, thanks.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

