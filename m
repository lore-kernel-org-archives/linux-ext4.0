From: Tao Ma <tm@tao.ma>
Subject: Re: working on extent locks for i_mutex
Date: Fri, 13 Jan 2012 15:14:51 +0800
Message-ID: <4F0FD9EB.5050707@tao.ma>
References: <4F0F9E97.1090403@linux.vnet.ibm.com> <20120113043411.GH2806@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:48055 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751126Ab2AMHO6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jan 2012 02:14:58 -0500
In-Reply-To: <20120113043411.GH2806@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/13/2012 12:34 PM, Dave Chinner wrote:
> On Thu, Jan 12, 2012 at 08:01:43PM -0700, Allison Henderson wrote:
>> Hi All,
>>
>> I know this is an old topic, but I am poking it again because I've
>> had some work items wrap up, and Im planning on picking up on this
>> one again.  I am thinking about implementing extent locks to replace
>> i_mutex.  So I just wanted to touch base with folks and see what
>> people are working on because I know there were some folks out there
>> that were thing about doing similar solutions.
> 
> What locking API are you looking at? If you are looking at an
> something like:
> 
> read_range_{try}lock(lock, off, len)
> read_range_unlock(lock, off, len)
> write_range_{try}lock(lock, off, len)
> write_range_unlock(lock, off, len)
> 
> and implementing with an rbtree or a btree for tracking, then I
> definitely have a use for it in XFS - replacing the current rwsem
> that is used for the iolock. Range locks like this are the only
> thing we need to allow concurrent buffered writes to the same file
> to maintain the per-write exclusion that posix requires.
Interesting, so xfs already have these range lock, right? If yes, any
possibility that the code can be reused in ext4 since we have the same
thing in mind but don't have any resource to work on it by now.

btw, IIRC flock(2) uses a list to indicate the range lock, so if we can
make these pieces of codes common, at least there are 3 places that can
benefit from it. ;)

Thanks
Tao
