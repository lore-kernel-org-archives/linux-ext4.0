From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Fri, 05 Jun 2009 17:02:28 -0500
Message-ID: <4A2995F4.8050901@redhat.com>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> <4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com> <4A294B15.9070209@tuffmail.co.uk> <4A29601F.3070802@redhat.com> <4A298EF5.9000504@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Aioanei Rares <krnl.list@gmail.com>, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33871 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZFEWCb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2009 18:02:31 -0400
In-Reply-To: <4A298EF5.9000504@tuffmail.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Alan Jenkins wrote:
> Eric Sandeen wrote:
>> Alan Jenkins wrote:

...

>> And did the reread after dropping caches have the right data?
>>   
> 
> Yes.
> 
>> Did the block numbers reported by filefrag -v change post-boot?
>>   
> 
> Oh, I didn't understand that's what you were asking for.

Yeah, after I saw that bug it does seem to be solely a data flushing
issue.  I was trying the testcase and looking at what is on-disk in the
original image, what's on-disk after the unmount, and what is seen in
the chroot, for the file in question.... 3 different answers.

(and oddly enough dropping caches doesn't show it; you have to
unmount/remount)

-Eric

