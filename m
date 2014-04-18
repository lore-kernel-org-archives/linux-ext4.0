From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext4: Remove arbitrary block value in
 __es_remove_extent()
Date: Fri, 18 Apr 2014 11:22:12 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404181058230.2128@localhost.localdomain>
References: <1397585302-27175-1-git-send-email-lczerner@redhat.com> <20140417161944.GJ18591@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaDRJWR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:17 -0400
In-Reply-To: <20140417161944.GJ18591@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Apr 2014, Theodore Ts'o wrote:

> Date: Thu, 17 Apr 2014 12:19:44 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 1/2] ext4: Remove arbitrary block value in
>     __es_remove_extent()
> 
> On Tue, Apr 15, 2014 at 08:08:21PM +0200, Lukas Czerner wrote:
> > In __es_remove_extent() we're storing seemingly arbitrary value
> > 0x7FDEADBEEF into block variable. I assume that the reason is just to
> > initialize the variable before the use because the actual value does not
> > matter at this point.
> > 
> > Just remove the arbitrary value and initialized block variable to zero
> > which is much less suspicious.
> 
> The whole point was for the value to be suspicious.  That way, if
> there is a bug, and we try to use that value, it is a large enough
> value that for most storage devices, we will get an I/O error (because
> the disk isn't that big :-) referencing that block value, and we'll
> have a bit of a hint where that suspicious value might have come from.

Aside from the fact that this is totally undocumented and there is
not even comment on what is that all about in couple of years we
might actually get file systems big enough that this would not be an
I/O error anymore (that might be a bit of a stretch).

But mainly this value is only going to be used if it is delayed
extent or a hole which implies that it has not been mapped and
pblock does not contain anything valid. And if we really screwed it
up and tried to use pblock of extent which is a hole or delayed
extent, then it would not help us anyway since the only place that
we actually set this is when splitting extent on removal.

Now I can see that in ext4_da_map_blocks() we're actually using ~0
value for the pblock which is a bit better I think as long as we're
using this reliably. So I'll resend the patch which will make sure
that we're using ~0 reliably when storin delayed, or hole extents in
the extent status tree. Does that make sense ?

-Lukas

> 
>        	      	     	   		   - Ted
