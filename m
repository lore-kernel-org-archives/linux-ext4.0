From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Metadata reservation for unwritten extent conversionjkj
Date: Thu, 14 Mar 2013 07:38:13 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303140736430.18319@dhcp-1-104.brq.redhat.com>
References: <alpine.LFD.2.00.1303131629350.7128@dhcp-1-104.brq.redhat.com> <alpine.LFD.2.00.1303131706180.18319@dhcp-1-104.brq.redhat.com> <20130313172521.GC5604@thunk.org> <alpine.LFD.2.00.1303131830570.18319@dhcp-1-104.brq.redhat.com>
 <20130314032118.GA11821@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-883735827-1363243100=:18319"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab3CNGiX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Mar 2013 02:38:23 -0400
In-Reply-To: <20130314032118.GA11821@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-883735827-1363243100=:18319
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 13 Mar 2013, Theodore Ts'o wrote:

> Date: Wed, 13 Mar 2013 23:21:18 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: Metadata reservation for unwritten extent conversion
> 
> On Wed, Mar 13, 2013 at 06:31:25PM +0100, Lukáš Czerner wrote:
> > > That sounds like the best thing to do.  I assume you will be simply
> > > taking the da_reserve_metadata() function introduced in the
> > > to-be-dropped commit:
> > > 
> > > > ext4: Reserve metadata if writing into uninitialized
> > > 
> > > ... and moving it into the "reserve metadata block for every delayed
> > > write" patch?
> 
> I wnated to kick off some testing tonight, so I've made this change to
> the git tree.  So the new version of "reserve metadata block for every
> delayed write" is here:
> 
> https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=c7cf7abbf754f16b78a8b9641d06baac6be60524
> 
> ... and the dev branch has been modified to drop the "reserve metadata
> if writing into unitialized.." commit.
> 
> 						- Ted

Great, thanks. It was quite late yesterday so I have not had time to
actually send the patch, sorry.

I'll send it today just for the "record-keeping" :)

Thanks!
-Lukas
--8323328-883735827-1363243100=:18319--
