From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Tue, 20 Apr 2010 19:26:33 +0200
Message-ID: <201004201926.33908.bernd.schubert@fastmail.fm>
References: <20100416123526.GW21495@skl-net.de> <20100420153723.GE25507@skl-net.de> <4BCDDB7F.6040903@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andre Noll <maan@systemlinux.org>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35419 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401Ab0DTR0g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Apr 2010 13:26:36 -0400
In-Reply-To: <4BCDDB7F.6040903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 20 April 2010, Eric Sandeen wrote:
> On 04/20/2010 10:37 AM, Andre Noll wrote:
> ...
> 
> > - device timeout 30s, nobarrier
> > 	No problem at all, all three runs OK.
> >
> > Eric, are you still interested in seeing the blktrace output? Suppose,
> > I should use a 30s timeout, nodealloc and barriers=1 as this triggers
> > the problem within minutes.
> 
> Hm, so something about barriers being issued is causing timeout
> problems on the device...?

I think interesting at this point would be the exact model of the Infortrend 
device. There are some completely broken models (IMHO), which have two 
controllers for redundancy. Now with enabled write-back cache, it can happen 
that those units run into some kind of firmware bug. It then takes about 2h to 
flush 2GB of write-back cache. The telnet interface will show the status of 
the cache. More recent IFT dual-controller units do not suffer from this bug 
anymore, but as Andre said, they are using an old unit...


Thanks,
Bernd



