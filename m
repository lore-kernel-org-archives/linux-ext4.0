From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 4/7] mke2fs: create a regular file if necessary
Date: Wed, 30 Apr 2014 16:35:12 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404301628010.2100@localhost.localdomain>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu> <1398556834-31913-4-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1404301410590.2100@localhost.localdomain> <20140430140657.GB9213@thunk.org> <alpine.LFD.2.00.1404301611290.2100@localhost.localdomain>
 <20140430141815.GE9213@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1062062614-1398868514=:2100"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933466AbaD3OfR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 10:35:17 -0400
In-Reply-To: <20140430141815.GE9213@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1062062614-1398868514=:2100
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 30 Apr 2014, Theodore Ts'o wrote:

> Date: Wed, 30 Apr 2014 10:18:15 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 4/7] mke2fs: create a regular file if necessary
> 
> On Wed, Apr 30, 2014 at 04:14:16PM +0200, Lukáš Czerner wrote:
> > > Hmm, it occurs to me if the user typo's the file name in and the user
> > > specifies the size explicitly (i.e., "mke2fs /dev/scd3 2T) , it could
> > > result in the the root file system filling up.  I'm not sure that's
> > > big of a deal, since the user can always control-C the mke2fs and then
> > > delete the typo'ed file name.  Do we think this is a real problem?
> > > I'm not too worried...
> > 
> > Oops, yes that would be nasty :) I'm not too worried either, but
> > I've done my share of typos as well, so I am not sure. And since
> > we're already asking a lot of questions anyway maybe we can ask
> > about this one as well ?
> 
> The problem is if we do this, then scripts will do "mke2fs -F ..." to
> avoid the query, and I'd really like to avoid training script authors
> to do this.  It undoes the point of some of the other patches in this
> patch series.

Yes, I do not like having to force people to use force either. Well,
there is a certain limit where we should go to correct user
mistakes and it seems that beyond that...

But having mkfs to print out the information that it's actually
creating the file is the least we can do.

-Lukas

> 
> We could have some proceed_questions() fail to "yes", and some fail to
> "no", but I'm wondering if we really want to go to that level of
> complexity....
> 
> 						- Ted
> 
--8323328-1062062614-1398868514=:2100--
