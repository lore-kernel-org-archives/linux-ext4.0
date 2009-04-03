From: "Nick Hennenfent (nhennefe)" <nhennefe@cisco.com>
Subject: RE: EXT4 in embedded systems
Date: Fri, 3 Apr 2009 13:15:15 -0400
Message-ID: <2FE093E39DAE7D498A29AF6BE01F267B04E42EE1@xmb-rtp-20c.amer.cisco.com>
References: <49D63408.3080907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Ext4 Developers List" <linux-ext4@vger.kernel.org>
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:10261 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZDCRPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Apr 2009 13:15:19 -0400
Content-class: urn:content-classes:message
In-Reply-To: <49D63408.3080907@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


We build IPTV settop boxes that are sold to telecom companies,
so our video comes into the box via a multicast IP stream.

Adding PVR/DVR/Tivo type functionality is becoming very popular
with end users.

As usual, in embedded systems, we have limited memory and cpu power.
We are currently using XFS for recording video to the hard disk, since
it uses less cpu than EXT3 did.

When a consumer is watching a High Def channel and recording a High Def
channel, we need all the extra performance we can get. We are hoping
that
the EXT4 file system will give us a performance boost.

People really hate it when they push a button on their remote and it
takes
a while for something to happen :)

Nick Hennenfent
Cisco IPTV
  

-----Original Message-----
From: Eric Sandeen [mailto:sandeen@redhat.com] 
Sent: Friday, April 03, 2009 12:07 PM
To: Nick Hennenfent (nhennefe)
Cc: Ext4 Developers List
Subject: Re: EXT4 in embedded systems

Nick Hennenfent (nhennefe) wrote:
> Hi all,
> 
> I am currently running kernel 2.6.15 on an embedded mips system.
> 
> I really would like to be able to use the ext4 file system.
> 
> I can easily upgrade to kernel 2.6.22 but not any further.
> 
> I would like to get the latest and greatest stable ext4 code onto this
> box.
> 
> Is it possible to back-port the latest ext4 code to the 2.6.22 kernel?
> 
> Or, is there a better way to go about it?

Hi Nick -

Well, "it's just code" :)  I'm sure it's possible to backport it, though
it'd be nontrivial, and unlikely to be something that will happen from
the upstream developers; backporting that far can often be significant
work, as the kernel APIs are constantly changing.  In my experience,
this requires more than just massaging fs/ext4 and fs/jbd2 into shape,
but requires careful core kernel changes at times as well.  It might be
the sort of thing you could find a contract for, I imagine there are
people who would be willing to do this.

Aside from all that though, I wonder if you can share the use case with
us?  It's always interesting to see how people choose to use various
filesystems for specific tasks, and this sounds like an interesting one.

Thanks,
-Eric

> Thanks,
> Nick Hennenfent
> Cisco IPTV


