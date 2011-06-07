From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 07 Jun 2011 09:59:18 -0400
Message-ID: <4DEE2EB6.2050901@redhat.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com> <BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com> <4DECF2D5.7050408@redhat.com> <alpine.LFD.2.00.1106061755260.3934@dhcp-27-109.brq.redhat.com> <20110606204028.GD20818@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"Amir G." <amir73il@users.sourceforge.net>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab1FGN7q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 09:59:46 -0400
In-Reply-To: <20110606204028.GD20818@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/06/2011 04:40 PM, Ted Ts'o wrote:
> On Mon, Jun 06, 2011 at 06:05:24PM +0200, Lukas Czerner wrote:
>> Well, we can also start ditching some unused features and tunnables, or
>> make it default and remove it from documentation so people will not use
>> it and we can get rid of some of the options in the future. For examle
>>
>> orlov
>> oldalloc
>> bsddf
>> minixdf
> I tried deprecated bsddf/minixdf, and got a complaint from a user who
> said they were using it.  Linus's rule is, "though shalt not break
> backwards compatibility", so I have up on it.  Realistically, the
> difference between these two is so small it's not really a big deal.
>
> Dropping the old allocator is probably a good idea at this point.  I
> very much doubt anyone is using it.
>
> 					- Ted
>

Can we argue that the user base that uses these ancient options can simply 
continue to use them in ext3 and use that fig leaf to kill them in ext4 going 
forwards?

Ric


