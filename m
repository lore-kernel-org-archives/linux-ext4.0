From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sun, 18 May 2008 10:49:49 -0400
Message-ID: <4830420D.4080608@gmail.com>
References: <482DDA56.6000301@redhat.com> <20080517002030.GA7374@mit.edu> <20080516173552.e88183d9.akpm@linux-foundation.org> <200805172048.34455.chris.mason@oracle.com> <20080518013641.GH16496@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-ker
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:7318 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761096AbYERSt7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 May 2008 14:49:59 -0400
Received: by an-out-0708.google.com with SMTP id d40so376848and.103
        for <linux-ext4@vger.kernel.org>; Sun, 18 May 2008 11:49:58 -0700 (PDT)
In-Reply-To: <20080518013641.GH16496@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sat, May 17, 2008 at 08:48:33PM -0400, Chris Mason wrote:
>   
>> Well, the barriers happen like so (even if we actually only do one
>> barrier in submit_bh, it turns into two)
>>
>> write log blocks
>> flush #1
>> write commit block
>> flush #2
>> write metadata blocks
>>
>> I'd agree with Ted, there's a fairly small chance of things get reordered 
>> around flush #1.  flush #2 is likely to have lots of reordering though.  It 
>> should be easy to create situations where the metadata for a transaction is 
>> written before the log blocks ever see the disk.
>>     
>
> True, but even with a very heavy fsync() workload, a commit doesn't
> cause the metadata blocks to be written until we have to do a journal
> truncate operation.  A heavy fsync() workload would increase how
> quickly we would use up the journal and need to do a journal truncate,
> though.
>
>   
>> EMC did a ton of automated testing around this when Jens and I did
>> the initial barrier implementations, and they were able to trigger
>> corruptions in fsync heavy workloads with randomized power offs.
>> I'll dig up the workload they used.
>>     
>
> I could imagine a mode which forces a barrier operation for commits
> triggered by fsync()'s, but not commits that occur due to a natural
> closing of transactions.  I'm not sure it's worth it, though, since
> many of the benchmarks that we care about (like Postmark) do use
> fsync() fairly heavily.
>
> The really annoying thing is that what is really needed is a way to
> make write barriers cheaper; we don't need to do a synchronous flush,
> but unfortunately for most drives there isn't any other way of keeping
> disk writes from getting reordered.
>
>   
The workload we used was to run our existing Centera application on a 
rack of boxes. The application is a bit special in that it does a 
digital signature on each file and never returns success for the client 
until an fsync is done on the server (kind of like synchronous NFS).

What we did for our test was to pound away on a rack of these boxes (say 
32 boxes, each with 4 large ATA or S-ATA drives) and then drop power to 
the whole rack.

All of our data file systems were reiserfs, some of the system 
partitions were ext2.

The test would be marked as passed if we could reboot all of the boxes 
and have the client validate  that the digital signature of all files 
written and ack'ed were valid. We also looked for issues seen during the 
reboot (fsck grumbles, corrupted directories, etc).

I didn't run the tests personally, but seem to recall that without 
barriers we routinely saw file system corruption on that reboot.

The hard thing is to figure out how to test this kind of scenario 
without dropping power. To expose the failure mode, it might be 
sufficient to drop power to a drive with smartctl (or, if you have hot 
swap bays, just pull them).

Just a personal note, my last day at EMC was this past Friday. Monday, I 
start working for Red Hat (focused on file systems) so I will have to 
figure out to get this kind of test going without all of my big EMC toys ;-)

ric

