From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: working on extent locks for i_mutex
Date: Mon, 16 Jan 2012 10:46:29 -0700
Message-ID: <4F146275.8090304@linux.vnet.ibm.com>
References: <4F0F9E97.1090403@linux.vnet.ibm.com> <20120113043411.GH2806@dastard>	<4F10992C.3070303@linux.vnet.ibm.com> <20120115235747.GA6922@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:37416 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab2APRrp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jan 2012 12:47:45 -0500
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Mon, 16 Jan 2012 10:47:44 -0700
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id A98AB19D804F
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2012 10:46:31 -0700 (MST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0GHkXsD236150
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2012 12:46:33 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0GHkWWd032558
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2012 12:46:32 -0500
In-Reply-To: <20120115235747.GA6922@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/15/2012 04:57 PM, Dave Chinner wrote:
> On Fri, Jan 13, 2012 at 01:50:52PM -0700, Allison Henderson wrote:
>> On 01/12/2012 09:34 PM, Dave Chinner wrote:
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
>>
>> Yes that is generally the idea I was thinking about doing, but at
>> the time, I was not thinking outside the scope of ext4.  You are
>> thinking maybe it should be in vfs layer so that it's something that
>> all the filesystems will use?  That seems to be the impression I'm
>> getting from folks.  Thx!
>
> Yes, that's what I'm suggesting. Not so much a vfs layer function,
> but a library (range locks could be useful outside filesystems) so
> locating it in lib/ was what I was thinking....
>
> Cheers,
>
> Dave.

Alrighty, that sounds good to me.  I will aim to keep it as general 
purpose as I can.  I am going to start some proto typing and will post 
back when I get something working.  Thx for the feedback all!  :)

Allison

