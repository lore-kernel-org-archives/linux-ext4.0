From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 - error with root drive mount
Date: Wed, 04 Feb 2009 18:59:18 -0600
Message-ID: <498A39E6.2010004@redhat.com>
References: <20090203191531.0dfe27a1@amd64linuxmsi.rentzhouse.lan>	<20090204062400.GZ14762@mit.edu>	<20090204093420.44cac139@amd64linuxmsi.rentzhouse.lan>	<4989BFEC.8020803@redhat.com> <20090204192911.78564f27@amd64linuxmsi.rentzhouse.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jimmy Rentz <jedynamic@bellsouth.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50528 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbZBEA7r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Feb 2009 19:59:47 -0500
In-Reply-To: <20090204192911.78564f27@amd64linuxmsi.rentzhouse.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jimmy Rentz wrote:
> On Wed, 04 Feb 2009 10:18:52 -0600
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> Jimmy Rentz wrote:
>>
>>> I am not sure how to reproduce this problem.  It seems random
>>> enough.  The system is a mythtv box so it happens to
>>> poweron/poweroff on a regular basis to record.    
>> Just to be clear, it does this in a controlled manner, right.
>>
>> -Eric
> You mean whether the poweron/poweroff part is done cleanly? 
> The system sets a wakeup time to poweron (to
> record) then calls poweroff (via a script).  

Right.  I just wanted to make clear to anyone who hasn't used mythtv
that it can cleanly shut down & restart; I didn't want "poweroff" to be
mistaken for "power fail" :)

-Eric
