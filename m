From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 7/7] mke2fs: only print the low-level file system stats
 in verbose mode
Date: Wed, 30 Apr 2014 16:25:35 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404301616380.2100@localhost.localdomain>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu> <1398556834-31913-7-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1404301316180.2100@localhost.localdomain> <20140430140150.GA9213@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1307934039-1398867937=:2100"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698AbaD3OZk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 10:25:40 -0400
In-Reply-To: <20140430140150.GA9213@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1307934039-1398867937=:2100
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 30 Apr 2014, Theodore Ts'o wrote:

> Date: Wed, 30 Apr 2014 10:01:50 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 7/7] mke2fs: only print the low-level file system stats in
>      verbose mode
> 
> On Wed, Apr 30, 2014 at 01:22:52PM +0200, Lukáš Czerner wrote:
> > On Sat, 26 Apr 2014, Theodore Ts'o wrote:
> > 
> > > Date: Sat, 26 Apr 2014 20:00:34 -0400
> > > From: Theodore Ts'o <tytso@mit.edu>
> > > To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> > > Cc: Theodore Ts'o <tytso@mit.edu>
> > > Subject: [PATCH 7/7] mke2fs: only print the low-level file system stats in
> > >     verbose mode
> > 
> > While I kind of like this, because mke2fs is really quite verbose as
> > it is. However I am afraid that this will break scripts for people.
> 
> Are there scripts that are really trying to parse the output of
> mke2fs?  The output hasn't really been _that_ stable.  I'm sure we've
> added stuff in the past, althoughg admittedly the this is the first
> time that we would be removing stuff.

Yes, that's what I worry about. Addition would most likely not break
grep, but removal will surely do. I am sure that there are admins
doing that.

It also does not help that other file systems are printing out
various "low level" information.

Despite the fact that parsing mkfs output is not the best thing to
do I am on the fence whether we want to break it or not.

> 
> > Also there are actually some useful information in that output like
> > block size, size of the file system and file system label if
> > specified. Also maybe having UUID in there will be also useful.
> 
> The block sizs is pretty much always 4k, and the file system label is
> only there if the user specified one on the command line.  I can see
> how the size and UUID might be useful, though.
> 
> How about if we just print the size and UUID?

Sounds good to me.

-Lukas

> 
> 						- Ted
> 
--8323328-1307934039-1398867937=:2100--
