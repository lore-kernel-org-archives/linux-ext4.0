From: "George Spelvin" <linux@horizon.com>
Subject: Re: mke2fs -O 64bit -E resize=<anything> divides by 0
Date: 12 Nov 2012 01:32:08 -0500
Message-ID: <20121112063208.16223.qmail@science.horizon.com>
References: <50A07D0D.9080101@redhat.com>
Cc: linux-ext4@vger.kernel.org, linux@horizon.com
To: adilger@dilger.ca, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:20831 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751290Ab2KLGcJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Nov 2012 01:32:09 -0500
In-Reply-To: <50A07D0D.9080101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> And given that the poor reporter is re-making his whole filesystem just
> because he found out that he can't grow past 16T:
>	"(wow, was *that* a nasty surprise)"
> it's understandable that he's trying to give it a rather large resize=
> value this time around.

Er... I was trying to give a *small* resize= value, actually, given that
the default is documented as 1000x the FS size at creation.  I don't have
a good mental model of what the space reservation entails, but given
*that* kind of default fudge factor, I added a small integer multiple
on top of what I thought would plausibly happen.
