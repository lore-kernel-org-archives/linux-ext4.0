From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 5/7] ext4: refactor truncate code
Date: Wed, 27 Mar 2013 14:31:48 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303271426420.18375@localhost>
References: <1364170014-10295-1-git-send-email-tytso@mit.edu> <1364170014-10295-6-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1303271128480.2455@(none)> <20130327123651.GG5861@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-271154726-1364391114=:18375"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab3C0Nb4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 09:31:56 -0400
In-Reply-To: <20130327123651.GG5861@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-271154726-1364391114=:18375
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 27 Mar 2013, Theodore Ts'o wrote:

> Date: Wed, 27 Mar 2013 08:36:51 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 5/7] ext4: refactor truncate code
> 
> On Wed, Mar 27, 2013 at 11:53:42AM +0100, Lukáš Czerner wrote:
> > > +	up_write(&ei->i_data_sem);
> > 
> > In ext_truncate we used to unlock it after the ext4_handle_sync(),
> > however in ind_truncate we used to unlock it before the
> > ext4_handle_sync(). Which one is correct ? I guess it does not have
> > to be done under the i_data_sem, so maybe we can move it outside the
> > semaphore in the punch_hole code as well ?
> 
> Yes, we can move this outside of the semaphore protected code.  Given
> that ext4_handle_sync() an inline function which sets a single memory
> location, my guess is that it didn't make a huge amount of difference,
> but it's better to keep the critical section as small as possible.
> I'll make that change.
> 
> 
> Hmm.... one thing I'm not sure about, now that I'm looking at this
> code.  We call ext4_discard_preallocations() twice; once before we
> remove the extent, and once afterwards.  I'm not sure why we're doing
> that.  It doesn't look to me like ext4_free_blocks() ever releases
> blocks back to the preallocation space.  Am I missing something, or
> could we eliminate one of the calls to ext4_discard_preallocations()?

I was wondering about that as well. There is a possibility of
allocation occurring in ext4_ext_remove_space() however it is only
metadata allocation and as such there should be no preallocation so
it seems to me that the second ext4_discard_preallocations() is
unnecessary. Note that it has been there from the introduction of
punch hole.

However let's take it one step further. What about the first call of
ext4_discard_preallocations() is this entirely necessary for a punch
hole ? I am wondering whether we can optimize things by dropping the
preallocation only within the hole we're punching, or possibly only
when we punch a hole at the end, or past the end of the file.

-Lukas

> 
>       	 	       	      	       - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-271154726-1364391114=:18375--
