From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Metadata reservation for unwritten extent conversion
Date: Wed, 13 Mar 2013 18:31:25 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303131830570.18319@dhcp-1-104.brq.redhat.com>
References: <alpine.LFD.2.00.1303131629350.7128@dhcp-1-104.brq.redhat.com> <alpine.LFD.2.00.1303131706180.18319@dhcp-1-104.brq.redhat.com> <20130313172521.GC5604@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-801663805-1363195888=:18319"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab3CMRba (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Mar 2013 13:31:30 -0400
In-Reply-To: <20130313172521.GC5604@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-801663805-1363195888=:18319
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 13 Mar 2013, Theodore Ts'o wrote:

> Date: Wed, 13 Mar 2013 13:25:21 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: Metadata reservation for unwritten extent conversion
> 
> On Wed, Mar 13, 2013 at 05:09:51PM +0100, Lukáš Czerner wrote:
> > 
> > Well, we can not actually revert that patch because it introduces
> > da_reserve_metadata() which is used elsewhere in the commit:
> > 
> > ext4: reserve metadata block for every delayed write
> > 
> > I can resend the patch which uses da_reserve_metadata() so you can use
> > it instead the old version
> 
> That sounds like the best thing to do.  I assume you will be simply
> taking the da_reserve_metadata() function introduced in the
> to-be-dropped commit:
> 
> > ext4: Reserve metadata if writing into uninitialized
> 
> ... and moving it into the "reserve metadata block for every delayed
> write" patch?

Exactly.

-Lukas

> 
> 					- Ted

--8323328-801663805-1363195888=:18319--
