From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Mon, 5 May 2014 16:17:10 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405051614320.2223@localhost.localdomain>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu> <1399295044-24489-2-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain> <20140505140401.GD22287@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-738359903-1399299433=:2223"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538AbaEEORP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 10:17:15 -0400
In-Reply-To: <20140505140401.GD22287@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-738359903-1399299433=:2223
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 5 May 2014, Theodore Ts'o wrote:

> Date: Mon, 5 May 2014 10:04:01 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
>     ext2/3/4 file systems
> 
> On Mon, May 05, 2014 at 03:45:17PM +0200, Lukáš Czerner wrote:
> > 
> > Now I am actually confused, sorry. Which patches do I need to get this
> > context? I do not see this in the next branch.
> 
> These are based on the mke2fs patches I had sent earlier.  Sorry, I
> haven't updated the maint branch in a while.
> 
> The basic idea behinid these patches is that we now get a bit more
> context with the warning message for ext2/3/4 file systems:
> 
> % ./misc/mke2fs -t ext4 /dev/heap/media
> mke2fs 1.42.9 (4-Feb-2014)
> /dev/heap/media contains a ext4 file system labelled 'media'
> 		  last mounted on /media on Mon May  5 08:59:53 2014
> Proceed anyway? (y,n) 
> 
> I have modified those earlier patches in response to your earlier
> feedback; we no longer use the 5 second delay by default --- but we
> skip doing the check at all if either stdin or stdout is not a tty.
> This saves us in the situation where there is some script which does
> somethign like this:
> 
> mke2fs -t ext4 /dev/sdc3 > /tmp/mke2fs.out
> 
> Basically, we will only ask the user for confirmation when we are
> certain a user can see both the question and be able to type a
> response.  It's possible we could still get confused by someone
> running mke2fs under a chat/expect script, but that seems like an
> acceptable risk.

Ok, that makes sense, thanks.

-Lukas

> 
> 
> 					- Ted
> 
--8323328-738359903-1399299433=:2223--
