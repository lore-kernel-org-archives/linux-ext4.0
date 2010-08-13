From: Evan Jones <evanj@MIT.EDU>
Subject: Re: Intel SSD data loss: Any possible way this is user / software error?
Date: Fri, 13 Aug 2010 12:07:19 -0400
Message-ID: <AD482FB5-0A56-43F2-BB70-8F218657DCE0@MIT.EDU>
References: <4C64615B.70308@mit.edu> <4C65331A.9050203@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:45772 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034Ab0HMQHe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Aug 2010 12:07:34 -0400
In-Reply-To: <4C65331A.9050203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 13, 2010, at 7:57 , Eric Sandeen wrote:
> Just out of curiosity, what do you see when the write cache is on?
> Seems counter-intuitive that it'd work better, but talking w/
> Ric Wheeler, he was curious... maybe Intel didn't test with the
> write cache off?

Data loss is much easier to trigger with the write cache on. It  
happens to me on the first try. With the write cache off, I've only  
been able to get it to occur with large writes (64 kB or larger), and  
only about once every 3 times.

Others have observed data loss with the write cache enabled using  
Intel SSDs. However, no one else seems to report data loss with the  
cache disabled, which makes me wonder if I am doing something wrong.  
With the X25-E:

http://www.mysqlperformanceblog.com/2009/03/02/ssd-xfs-lvm-fsync-write-cache-barrier-and-lost-transactions/

And with the X25-M G2:

http://thread.gmane.org/gmane.os.solaris.opensolaris.zfs/33472


> Also, would you be willing to publish the test you're using?

The programs I have been using are here (but see below):

http://people.csail.mit.edu/evanj/hg/index.cgi/hstore/file/tip/logging/minlogcrash.c
http://people.csail.mit.edu/evanj/hg/index.cgi/hstore/file/tip/logging/logfilecrashserver.cc

minlogcrash.c is actually a simplified version of my *real* test  
program (below). However, that program has a lot of dependencies and  
unrelated crap. Unfortunately, I'm away from my hardware for the next  
10 days or so, so minlogcrash has not actually been crash tested. I  
think it should be equivalent, but just in case, the crash tested  
version is here:

http://people.csail.mit.edu/evanj/hg/index.cgi/hstore/file/tip/logging/logfilecrash.cc


My test procedure:

1. Start logfilecrashserver on a workstation:

./logfilecrashserver 12345

2. Start minlogcrash on the system under test (using large writes is  
more likely to lose data: 128 kB or so):

./minlogcrash tmp workstation 12345 131072

3. Once the workstation starts receiving log records, pull the power  
from the back of the SSD.
4. Power off the system (my system doesn't support hotplug, so losing  
the power on the SSD makes it unhappy)
5. Reconnected power to the SSD.
6. Power the server back on.
7. Observe the output of logfilecrash using hexdump.

You should find that the file has *at least* the last record reported  
by logfilecrashserver. It may have (part of) the next record. Error  
modes I have observed: it is missing the last reported record  
entirely; it has a truncated record; occasionally I get some sort of  
media error in the kernel and I can't read the entire file.

Finally full disclosure: I tested this a lot more with the Intel SSD  
than with my magnetic disks. With the magnetic disks and barrier=0, I  
was able to very easily see "lost writes", but with barrier=1 it  
seemed to work. However, I still need to go back and re-test the  
magnetic disks multiple times, to ensure they are behaving the way I  
expect.

Evan

--
Evan Jones
http://evanjones.ca/

