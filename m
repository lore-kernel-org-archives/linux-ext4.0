From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: working on extent locks for i_mutex
Date: Fri, 13 Jan 2012 13:50:52 -0700
Message-ID: <4F10992C.3070303@linux.vnet.ibm.com>
References: <4F0F9E97.1090403@linux.vnet.ibm.com> <20120113043411.GH2806@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:41808 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab2AMUu6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jan 2012 15:50:58 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 13 Jan 2012 13:50:57 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0DKosq9121920
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jan 2012 13:50:55 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0DKosBa019530
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jan 2012 13:50:54 -0700
In-Reply-To: <20120113043411.GH2806@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/2012 09:34 PM, Dave Chinner wrote:
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
>
> Cheers,
>
> Dave.

Yes that is generally the idea I was thinking about doing, but at the 
time, I was not thinking outside the scope of ext4.  You are thinking 
maybe it should be in vfs layer so that it's something that all the 
filesystems will use?  That seems to be the impression I'm getting from 
folks.  Thx!

Allison Henderson

