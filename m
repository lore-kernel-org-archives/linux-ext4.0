From: Tao Ma <tm@tao.ma>
Subject: Re: working on extent locks for i_mutex
Date: Fri, 13 Jan 2012 19:57:21 +0800
Message-ID: <4F101C21.1050708@tao.ma>
References: <4F0F9E97.1090403@linux.vnet.ibm.com> <20120113043411.GH2806@dastard> <4F0FD9EB.5050707@tao.ma> <20120113115232.GI2806@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:34958 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751683Ab2AML52 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jan 2012 06:57:28 -0500
In-Reply-To: <20120113115232.GI2806@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/13/2012 07:52 PM, Dave Chinner wrote:
> On Fri, Jan 13, 2012 at 03:14:51PM +0800, Tao Ma wrote:
>> On 01/13/2012 12:34 PM, Dave Chinner wrote:
>>> On Thu, Jan 12, 2012 at 08:01:43PM -0700, Allison Henderson wrote:
>>>> Hi All,
>>>>
>>>> I know this is an old topic, but I am poking it again because I've
>>>> had some work items wrap up, and Im planning on picking up on this
>>>> one again.  I am thinking about implementing extent locks to replace
>>>> i_mutex.  So I just wanted to touch base with folks and see what
>>>> people are working on because I know there were some folks out there
>>>> that were thing about doing similar solutions.
>>>
>>> What locking API are you looking at? If you are looking at an
>>> something like:
>>>
>>> read_range_{try}lock(lock, off, len)
>>> read_range_unlock(lock, off, len)
>>> write_range_{try}lock(lock, off, len)
>>> write_range_unlock(lock, off, len)
>>>
>>> and implementing with an rbtree or a btree for tracking, then I
>>> definitely have a use for it in XFS - replacing the current rwsem
>>> that is used for the iolock. Range locks like this are the only
>>> thing we need to allow concurrent buffered writes to the same file
>>> to maintain the per-write exclusion that posix requires.
>> Interesting, so xfs already have these range lock, right? If yes, any
>> possibility that the code can be reused in ext4 since we have the same
>> thing in mind but don't have any resource to work on it by now.
> 
> No, it doesn't have range locks. If has separate locks for IO
> exclusion vs metadata modification (i_iolock vs i_ilock). Both are
> rwsems, the ilock nests inside and protects the extent list and
> other metadata.
> 
> What I want to do is replace the i_iolock with a read/write range
> lock so that we can do sane cache coherent concurrent IO to separate
> ranges of the file. We can't do concurrent modifications to the
> extent tree, so we have no need for changing the i_ilock (metadata)
> lock to range locks.
OK, I see. Thanks for the information.
> 
> 
>> btw, IIRC flock(2) uses a list to indicate the range lock, so if we can
>> make these pieces of codes common, at least there are 3 places that can
>> benefit from it. ;)
> 
> flock is way more complex than simple read/write range locks and has
> fixed semantics and lots of scope for difficult to find regressions,
> so I wouldn't even bother trying to support them...
fair enough. :)

Thanks
Tao
