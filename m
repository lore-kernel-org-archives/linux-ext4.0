From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 17:21:27 -0700
Message-ID: <CALCETrUm0C+3etmsve7kQwspaycXnj4ZWNTWi+C5r4r-pahqUw@mail.gmail.com>
References: <20130815021028.GM6023@dastard> <CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
 <20130815060149.GP6023@dastard> <CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
 <20130815071141.GQ6023@dastard> <CALCETrWyKSMDkgSbg20iWBRfHk0-oU+6A3X9xAEMg3vO=G_gDg@mail.gmail.com>
 <20130815213725.GT6023@dastard> <CALCETrV7F-47_nRx1AVFqeF8sNoREutbo3kf78ddBLvKKmFCzg@mail.gmail.com>
 <20130815221807.GW6023@dastard> <CALCETrVgSsJD8L5kDUp8JAhhjEoAZYCfOfAE7Mx-=2pbFnPESQ@mail.gmail.com>
 <20130816001435.GZ6023@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	xfs@oss.sgi.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:45986 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3HPAVs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Aug 2013 20:21:48 -0400
Received: by mail-ve0-f169.google.com with SMTP id db10so1090508veb.0
        for <linux-ext4@vger.kernel.org>; Thu, 15 Aug 2013 17:21:48 -0700 (PDT)
In-Reply-To: <20130816001435.GZ6023@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 15, 2013 at 5:14 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Aug 15, 2013 at 03:26:09PM -0700, Andy Lutomirski wrote:
>> On Thu, Aug 15, 2013 at 3:18 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Thu, Aug 15, 2013 at 02:43:09PM -0700, Andy Lutomirski wrote:
>> >> On Thu, Aug 15, 2013 at 2:37 PM, Dave Chinner
>> >> <david@fromorbit.com> wrote:
>> >> > On Thu, Aug 15, 2013 at 08:17:18AM -0700, Andy Lutomirski wrote:
>
>> >> In current kernels, this chain of events won't work:
>> >>
>> >>  - Server goes down
>> >>  - Server comes up
>> >>  - Userspace on server calls mmap and writes something
>> >>  - Client reconnects and invalidates its cache
>> >>  - Userspace on server writes something else *to the same page*
>> >>
>> >> The client will never notice the second write, because it won't update
>> >> any inode state.
>> >
>> > That's wrong. The server wrote the dirty page before the client
>> > reconnected, therefore it got marked clean.
>>
>> Why would it write the dirty page?
>
> Terminology mismatch - you said it "writes something", not "dirties
> the page". So, it's easy to take that as "does writeback" as opposed
> to "dirties memory".

When I say "writes something" I mean literally performs a store to
memory.  That is:

ptr[offset] = value;

In my example, the client will *never* catch up.

>
>> > The second write to the
>> > server page marks it dirty again, causing page_mkwrite to be
>> > called, thereby updating the timestamp/i_version field. So, the NFS
>> > client will notice the second change on the server, and it will
>> > notice it immediately after the second access has occurred, not some
>> > time later when:
>> >
>> >> With my patches, the client will as soon as the
>> >> server starts writeback.
>> >
>> > Your patches introduce a 30+ second window where a file can be dirty
>> > on the server but the NFS server doesn't know about it and can't
>> > tell the clients about it because i_version doesn't get bumped until
>> > writeback.....
>>
>> I claim that there's an infinite window right now, and that 30 seconds
>> is therefore an improvement.
>
> You're talking about after the second change is made. I'm talking
> about the difference in behaviour after the *initial change* is
> made. Your changes will result in the client not doing an
> invalidation because timestamps don't get changed for 30s with your
> patches.  That's the problem - the first change of a file needs to
> bump the i_version immediately, not in 30s time.
>
> That's why delaying timestamp updates doesn't fix the scalability
> problem that was reported. It might fix a different problem, but it
> doesn't void the *requirment* that filesystems need to do
> transactional updates during page faults....
>

And this is why I'm unconvinced that your requirement is sensible.
It's attempting to make sure that every mmaped write results in a some
kind of FS update, but it actually only results in an FS update
*before* the *first* mmapped write after writeback.  It's racy as
hell.

My approach is slow but not racy.

--Andy
