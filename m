From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: delayed extent tree test cases
Date: Fri, 09 Mar 2012 09:40:23 -0700
Message-ID: <4F5A3277.40506@linux.vnet.ibm.com>
References: <4F5992B6.7070105@linux.vnet.ibm.com> <CAGBYx2Y8mJJ05=XcTYUVK07deS2GFUCrTVJoZy9Jaj7958OsEA@mail.gmail.com> <4F59A599.4050400@linux.vnet.ibm.com> <CAGBYx2binmZZnOsEva0e_vxWhzFSv6gVnU35yRVyWTSXGXKp=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@linux.vnet.ibm.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34801 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab2CIQlQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2012 11:41:16 -0500
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 9 Mar 2012 09:41:15 -0700
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 9860A19D8048
	for <linux-ext4@vger.kernel.org>; Fri,  9 Mar 2012 09:40:37 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q29GeQUF254424
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 09:40:30 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q29GeP6D001479
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 09:40:26 -0700
In-Reply-To: <CAGBYx2binmZZnOsEva0e_vxWhzFSv6gVnU35yRVyWTSXGXKp=A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/09/2012 02:19 AM, Yongqiang Yang wrote:
>> Alrighty, I'll give it a run through xfstests tonight, and then maybe I can
>> show you what I've got so far.  My first few patches are pretty much just
>> renaming things from delayed_extent to status_extent, sense it's doing a lot
>> more than delayed extents now.  I figured those patches we could just merge
>> together sense I dont think your set has been merged yet.
> Agree!  This can reduce Ted's work.
>
>>
>> The next step that I am working on now is getting it to track allocated
>> extents.  So any pointers for doing that would be helpful :)  It looks like
>> the current code is optimized for merging extents as much as possible, and
>> that makes sense for delayed extents, but for allocated extents, we need to
> Yep, it is optimized much for delayed extents.
>> get it to mirror the existing extents.  That way we will know what extents
>> there are to lock before we start doing things with the current extent tree.
>>
>> When I think about all the ins and outs of trying to keep the trees in sync,
> Actually, delayed extents is also synced.  This can be easily achieved
> by protecting operations on extent tree by i_data_sem.
Ah, sorry I could have phrased that better.  What I meant was trying to 
keep the new status tree in sync with the on disk tree so that the 
status tree mirrors the same allocated extents in the on disk tree.
>
>> I realize it may get complex, but I dont think we would want to deal with
>> the odd things that might come out of allowing tasks to lock a partial
>> extent either.  Suggestions for simplifications are certainly welcome though
>> :)
> I am a little confused by partial extent here.  I am guessing you
> meant extent rb-tree in memory is the mirror of extent tree in inode
> which is stored on disk.  Am I right?
>
> In my head, the extent tree used by extent lock traces logical
> extents, for example, a process locks a range of a file and it does
> not care the physical blocks.    So we just need to record logical
> extent without physical blocks infos.  Then locking on an extent may
> trigger splitting on an extent while unlocking may trigger merging on
> extents.  Am I right?
>
> Yongqiang.
>

Well initially I was doing something similar to that, where we only lock 
logical ranges that may or may not be "extent aligned" with the on disk 
extents.  But the concern that I have though is that we may end up with 
processes that have the same on disk extent locked.  For example, say 
process A locks a logical range of blocks, 1-5 and process B locks a 
logical range of blocks 6-10.  But if the on disk extents are actually 
1-2, 3-7 and 8-10, we have a situation where both processes own a piece 
of the 3-7 extent, but they wont know it until they get down into the on 
disk extents.  And it seems to me they should really have the whole on 
disk extent locked before they do any on disk splitting.  And now we 
have a deadlock condition since one of them is going to have to give up 
their lock before the other can proceed.  So that's when I started 
thinking maybe we need to make sure that the locked ranges are extent 
aligned.  Does that make sense?  Maybe there is something I am 
overlooking that would help simplify.

Allison Henderson

>
>>
>> Thx!
>> Allison Henderson
>>
>
>
>

