From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: kernel BUG at fs/ext4/inode.c:1184!
Date: Sat, 03 Oct 2009 19:06:27 +0200
Message-ID: <4AC78493.3020301@infracom.it>
References: <4AC71ECC.2020104@infracom.it> <20091003111515.GA2032@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	torvalds@linux-foundation.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bfexch.netexchange.int.netscalibur.it ([62.196.3.41]:35706 "EHLO
	bfexch.netexchange.int.netscalibur.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908AbZJCRHR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Oct 2009 13:07:17 -0400
In-Reply-To: <20091003111515.GA2032@phenom2.trippelsdorf.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Markus Trippelsdorf ha scritto, Il 03/10/2009 13:15:
> On Sat, Oct 03, 2009 at 11:52:12AM +0200, Roberto Oppedisano wrote:
>   
>> This is 100% reproducible on current git kernel.
>> After hitting the BUG the machine is still alive, but some processes
>> refuse to start and /bin/sync stalls forever.
>> Last known good kernel is 2.6.32-rc2-00087-g9c1fe83.
>>
>> [   74.971246] ------------[ cut here ]------------
>> [   74.971303] kernel BUG at fs/ext4/inode.c:1184!
>>     
>
> This is already fixed, see:
> http://marc.info/?l=linux-ext4&m=125437926005433&w=4
>
> Unfortunately Linus has not pulled the fix yet.
>   
yep. The patch works for me.

Thanks.

R

