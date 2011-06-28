From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 28 Jun 2011 14:30:55 -0500
Message-ID: <CA718FEC-341E-4D17-90FA-6181A0487CC9@boeing.com>
References: <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
 <alpine.LFD.2.00.1106271312310.3845@dhcp-27-109.brq.redhat.com>
 <20110627140251.GI5597@quack.suse.cz>
 <alpine.LFD.2.00.1106271714350.3845@dhcp-27-109.brq.redhat.com>
 <20110627160140.GC2729@thunk.org>
 <2D8D1A30-C092-4163-B47A-BCEDACE536A3@boeing.com>
 <20110628093652.GA29978@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Sean Ryle <seanbo@gmail.com>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blv-smtpout-01.boeing.com ([130.76.32.69]:61887 "EHLO
	blv-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1F1UZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jun 2011 16:25:55 -0400
In-Reply-To: <20110628093652.GA29978@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is really helpful to me, but it's deviated a bit from solving
the original bug.  Based on the last log that I generated showing that
the error occurs in journal_stop(), what else should I be testing?

Further discussion of the exact behavior of data-journalling below:

On Jun 28, 2011, at 05:36, Jan Kara wrote:
> On Mon 27-06-11 23:21:17, Moffett, Kyle D wrote:
>> On Jun 27, 2011, at 12:01, Ted Ts'o wrote:
>>> That being siad, it is true that data=journalled isn't necessarily
>>> faster.  For heavy disk-bound workloads, it can be slower.  So I can
>>> imagine adding some documentation that warns people not to use
>>> data=journal unless they really know what they are doing, but at least
>>> personally, I'm a bit reluctant to dispense with a bug report like
>>> this by saying, "oh, that feature should be deprecated".
>> 
>> I suppose I should chime in here, since I'm the one who (potentially
>> incorrectly) thinks I should be using data=journalled mode.
>> 
>> Please correct me if this is horribly horribly wrong:
>> 
>> [...]
>> 
>> no journal:
>>  Nothing is journalled
>>  + Very fast.
>>  + Works well for filesystems that are "mkfs"ed on every boot
>>  - Have to fsck after every reboot
> 
> Fsck is needed only after a crash / hard powerdown. Otherwise completely
> correct. Plus you always have a possibility of exposing uninitialized
> (potentially sensitive) data after a fsck.

Yes, sorry, I dropped the word "hard" from "hard reboot" while editing... oops.

> Actually, normal desktop might be quite happy with non-journaled filesystem
> when fsck is fask enough.

No, because fsck can occasionally fail on a non-journalled filesystem, and
then the Joe user is sitting there staring at an unhappy console prompt with
a lot of cryptic error messages.

It's also very bad for any kind of embedded or server environment that might
need to come back up headless.


>> data=ordered:
>>  Data appended to a file will be written before the metadata
>>  extending the length of the file is written, and in certain cases
>>  the data will be written before file renames (partial ordering),
>>  but the data itself is unjournalled, and may be only partially
>>  complete for updates.
>>  + Does not write data to the media twice
>>  + A crash or power failure will not leave old uninitialized data
>>    in files.
>>  - Data writes to files may only partially complete in the event
>>    of a crash.  No problems for logfiles, or self-journalled
>>    application databases, but others may experience partial writes
>>    in the event of a crash and need recovery.
> 
> Correct, one should also note that noone guarantees order in which data
> hits the disk - i.e. when you do write(f,"a"); write(f,"b"); and these are
> overwrites it may happen that "b" is written while "a" is not.

Yes, right, I should have mentioned that too.  If a program wants
data-level ordering then it must issue an fsync() or fdatasync().

Just to confirm, an file write in data=ordered mode can be only
partially written during a hard shutdown:
  char a[512] = "aaaaaaaaaaaaaaa"...;
  char b[512] = "bbbbbbbbbbbbbbb"...;
  write(fd, a, 512);
  fsync(fd);
  write(fd, b, 512);  <== Hard poweroff here
  fsync(fd);

The data on disk could contain any mix of "b"s and "a"s, and possibly
even garbage data depending on the operation of the disk firmware,
correct?


>> data=journalled:
>>  Data and metadata are both journalled, meaning that a given data
>>  write will either complete or it will never occur, although the
>>  precise ordering is not guaranteed.  This also implies all of the
>>  data<=>metadata guarantees of data=ordered.
>>  + Direct IO data writes are effectively "atomic", resulting in
>>    less likelihood of data loss for application databases which do
>>    not do their own journalling.  This means that a power failure
>>    or system crash will not result in a partially-complete write.
> 
> Well, direct IO is atomic in data=journal the same way as in data=ordered.
> It can happen only half of direct IO write is done when you hit power
> button at the right moment - note this holds for overwrites.  Extending
> writes or writes to holes are all-or-nothing for ext4 (again both in
> data=journal and data=ordered mode).

My impression of journalled data was that a single-sector write would
be written checksummed into the journal and then later into the actual
filesystem, so it would either complete (IE: journal entry checksum is
OK and it gets replayed after a crash) or it would not (IE: journal
entry does not checksum and therefore the later write never happened
and the entry is not replayed).

Where is my mental model wrong?


>>  - Cached writes are not atomic
>>  + For small cached file writes (of only a few filesystem pages)
>>    there is a good chance that kernel writeback will queue the
>>    entire write as a single I/O and it will be "protected" as a
>>    result.  This helps reduce the chance of serious damage to some
>>    text-based database files (such as those for some Wikis), but
>>    is obviously not a guarantee.
> Page sized and page aligned writes are atomic (in both data=journal and
> data=ordered modes). When a write spans multiple pages, there are chances
> the writes will be merged in a single transaction but no guarantees as you
> properly write.

I don't know that our definitions of "atomic write" are quite the same...

I'm assuming that filesystem "atomic write" means that even if the disk
itself does not guarantee that a single write will either complete or it
will be discarded, then the filesystem will provide that guarantee.

Cheers,
Kyle Moffett
