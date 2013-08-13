From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Mon, 12 Aug 2013 22:21:45 -0500
Message-ID: <5209A649.90406@redhat.com>
References: <51E88ECD.3040806@redhat.com> <20130719025934.GE17938@thunk.org> <20130719033309.GQ11674@dastard> <20130719161930.GF17938@thunk.org> <20130722013831.GE11674@dastard> <20130722021742.GA24195@gmail.com> <20130722100255.GF11674@dastard> <20130722125745.GA2827@gmail.com> <20130730030807.GI21982@dastard> <20130804012740.GC19781@thunk.org> <20130813031057.GV12779@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab3HMDVv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Aug 2013 23:21:51 -0400
In-Reply-To: <20130813031057.GV12779@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/12/13 10:10 PM, Dave Chinner wrote:
> On Sat, Aug 03, 2013 at 09:27:40PM -0400, Theodore Ts'o wrote:
>> On Tue, Jul 30, 2013 at 01:08:07PM +1000, Dave Chinner wrote:
>>> But Ted's case is not a "hint" - it's a direct command to fetch the
>>> extent map from disk. You can do that already with FIEMAP, so no new
>>> code or interfaces are needed. fadvise() is not the proper interface
>>> for manipulating filesystem metadata behaviour, and fiemap can
>>> already do what you need. There is no need for any new interfaces
>>> here.
>>
>> I've been looking at the definition of fiemap, and I'm not convinced.
>> To quote from the fiemap.txt:
>>
>>    The fiemap ioctl is an efficient method for userspace to get file
>>    extent mappings.

Ted - 

Changing fiemap.txt is easy, if that's the only problem... :)

>> That's not what is going on here.  We are pre-caching them into kernel
>> memory, not in user-space.  In addition, we're also setting a flag to
>> keep these extents preferentially in memory compared to other entries
>> in the extent cache.

Reading extents via fiemap almost certainly moves that metadata into
kernel cache, simply by the act of reading the block device to get them.

It doesn't set any caching preference, but how needed is that, really,
in practice?

>> I agree that posix_fadvise() isn't really a good match, either:
>>
>>    "posix_fadvise - predeclare an access pattern for file data"
>>
>> How about this?  FIEMAP is an ioctl, anyway.  How about if we just
>> declare this as a new fs-independent ioctl, much like FS_IOC_FIEMAP?
>>
>> #define FS_IOC_PRECACHE_EXTENTS    _IO('f', 18)
>>
>> This is, of course, assuming that other file systems are interested in
>> implementing this functionality.  If not, we can just keep it as
>> EXT4_IOC_PRECACHE_EXTENTS, and just call it a day.  (We can always add
>> a definition of FS_IOC_PRECACHE_EXTENTS set to ext4 ioctl's code
>> point, at some later point, if people change their minds.)
> 
> We *don't need to add any code* to the kernel to read extents into
> the kernel cache. The FIEMAP interface as it exists today -without
> modification- fulfils your stated requirement. 
> 
> I do no see any reason for adding a new, duplicated interface that
> we have to maintain and hook up to all the relevant filesystems,
> write test code for and then support forever more. It just makes no
> sense at all.

I see Dave's point that we _do_ have an interface today to read
all file extents into cache.  We don't mark them as particularly sticky,
however.

This seems pretty clearly driven by a Google workload need; something you
can probably test.  Does FIEMAP do the job for you or not?  If not, why not?

-Eric

> Cheers,
> 
> Dave.
> 

