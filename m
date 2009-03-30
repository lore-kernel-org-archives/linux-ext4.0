From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
Date: Mon, 30 Mar 2009 10:16:51 -0400
Message-ID: <49D0D453.4000307@redhat.com>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> 	<1238187031.27455.212.camel@think.oraclecorp.com> <1238187818.27455.217.camel@think.oraclecorp.com> 	<20090327213052.GC5176@mit.edu> <20090327215454.GH31071@duck.suse.cz> 	<20090327230902.GG5176@mit.edu> <49CD6BCC.6080602@garzik.org> <72dbd3150903271724n5e7900a5j2486707565cd9d74@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: David Rees <drees76@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49614 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZC3OUe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Mar 2009 10:20:34 -0400
In-Reply-To: <72dbd3150903271724n5e7900a5j2486707565cd9d74@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

David Rees wrote:
> On Fri, Mar 27, 2009 at 5:14 PM, Jeff Garzik <jeff@garzik.org> wrote:
>   
>> Theodore Tso wrote:
>>     
>>> OTOH, the really big databases will tend to use direct I/O, so they
>>> won't be dirtying the page cache anyway.  So maybe it's not worth the
>>>       
>> Not necessarily...  From what I understand, a lot of the individual
>> low-level components in cloud storage, such as GoogleFS's chunk server[1] do
>> not bypass the page cache, even though they do care about the details of
>> data caching and data consistency.
>>     
>
> PostgreSQL does not use direct I/O, either (except for the
> write-ahead-logs which are written sequentially and only get read
> during database recovery).  I'm sure that most of MySQL's database
> engines, also don't.
>
> -Dave
>   

The high end, traditional databases like DB2 and Oracle definitely do 
tend to use direct I/O and manage the cache vs not cached pages 
carefully on their own.

They also tend to use database "page sizes" larger than our VM page 
size  or FS block size and work hard to send large, aligned IO's down to 
storage in the correct order so they can be fully recoverable after a 
crash (no partially updated DB pages, aka "torn pages").

A lot of the cloud storage people rely on whole files. For example, you 
implement RAID at the file level by breaking your file down into K 
chunks, each one sent over the network to different machines. That chunk 
is really a whole file and is sent to disk (hopefully with an fsync()!) 
before ack'ing the transaction. They don't worry about data integrity 
for objects less than that chunk size.

At least, this is how we did it in Centera - without doing that, you are 
definitely open to data loss.

Ric



