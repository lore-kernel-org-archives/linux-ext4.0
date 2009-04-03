From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 in embedded systems
Date: Fri, 03 Apr 2009 11:06:32 -0500
Message-ID: <49D63408.3080907@redhat.com>
References: <2FE093E39DAE7D498A29AF6BE01F267B04E42DE6@xmb-rtp-20c.amer.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Nick Hennenfent (nhennefe)" <nhennefe@cisco.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58482 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935163AbZDCQHK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2009 12:07:10 -0400
In-Reply-To: <2FE093E39DAE7D498A29AF6BE01F267B04E42DE6@xmb-rtp-20c.amer.cisco.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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


