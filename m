From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Wed, 26 Aug 2009 09:37:49 -0400
Message-ID: <4A953AAD.2000707__20144.031282007$1251293870$gmane$org@redhat.com>
References: <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <20090826011605.GS4300@elf.ucw.cz> <20090826025514.GE32712@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbZHZNhU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2009 09:37:20 -0400
In-Reply-To: <20090826025514.GE32712@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/25/2009 10:55 PM, Theodore Tso wrote:
> On Wed, Aug 26, 2009 at 03:16:06AM +0200, Pavel Machek wrote:
>> Hi!
>>
>>> 3) Does that mean that you shouldn't use ext3 on RAID drives?  Of
>>> course not!  First of all, Ext3 still saves you against kernel panics
>>> and hangs caused by device driver bugs or other kernel hangs.  You
>>> will lose less data, and avoid needing to run a long and painful fsck
>>> after a forced reboot, compared to if you used ext2.  You are making
>>
>> Actually... ext3 + MD RAID5 will still have a problem on kernel
>> panic. MD RAID5 is implemented in software, so if kernel panics, you
>> can still get inconsistent data in your array.
>
> Only if the MD RAID array is running in degraded mode (and again, if
> the system is in this state for a long time, the bug is in the system
> administrator).  And even then, it depends on how the kernel dies.  If
> the system hangs due to some deadlock, or we get an OOPS that kills a
> process while still holding some locks, and that leads to a deadlock,
> it's likely the low-level MD driver can still complete the stripe
> write, and no data will be lost.  If the kernel ties itself in knots
> due to running out of memory, and the OOM handler is invoked, someone
> hitting the reset button to force a reboot will also be fine.
>
> If the RAID array is degraded, and we get an oops in interrupt
> handler, such that the system is immediately halted --- then yes, data
> could get lost.  But there are many system crashes where the software
> RAID's ability to complete a stripe write would not be compromised.
>
>         	       	  	     	    	  	- Ted

Just to add some real world data, Bianca Schroeder published a really good paper 
that looks at failures in national labs which has actual measured disk failures:

http://www.cs.cmu.edu/~bianca/fast07.pdf

Her numbers showed various rates of failures, but depending on the box, drive 
type, etc, they lost between 1-6% of the install drives each year.

There is also a good paper from Google:

http://labs.google.com/papers/disk_failures.html

Both of the above are largely linux boxes.

And several other FAST papers on failures in commercial RAID boxes, most notably 
by NetApp.

If reading papers is not at the top of your list of things to do, just skim 
through and look for the tables on disk failures, etc. which have great 
measurements of what really failed in these systems...

Ric





