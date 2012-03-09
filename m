From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: delayed extent tree test cases
Date: Thu, 08 Mar 2012 23:39:21 -0700
Message-ID: <4F59A599.4050400@linux.vnet.ibm.com>
References: <4F5992B6.7070105@linux.vnet.ibm.com> <CAGBYx2Y8mJJ05=XcTYUVK07deS2GFUCrTVJoZy9Jaj7958OsEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@linux.vnet.ibm.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51507 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab2CIGj2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Mar 2012 01:39:28 -0500
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 9 Mar 2012 01:39:27 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id DA1C538C8052
	for <linux-ext4@vger.kernel.org>; Fri,  9 Mar 2012 01:39:24 -0500 (EST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q296dOBm290116
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 01:39:24 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q29CAGL7002468
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 07:10:17 -0500
In-Reply-To: <CAGBYx2Y8mJJ05=XcTYUVK07deS2GFUCrTVJoZy9Jaj7958OsEA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/08/2012 10:36 PM, Yongqiang Yang wrote:
> On Fri, Mar 9, 2012 at 1:18 PM, Allison Henderson
> <achender@linux.vnet.ibm.com>  wrote:
>> Hi Yongqiang,
> Hi Allison,
>
>
>>
>> I am looking for test cases to exercise your delayed extent tree patch set.
>> I am working on expanding your solution for extent locks, and it would be
>> nice to have some sanity checks as I go along to make sure I have not broken
>> it :)  Are there any tests in particular that you used while you were
>> developing it?  Thx!
>
>       There is no particular tests for delayed extents tree on my hand.
>   I just tested the patch set with xfstests.   If there is any help I
> can provide, please tell me.
>
> Yongqiang.
>
>>
>> Allison Henderson
>>
>
>
>

Alrighty, I'll give it a run through xfstests tonight, and then maybe I 
can show you what I've got so far.  My first few patches are pretty much 
just renaming things from delayed_extent to status_extent, sense it's 
doing a lot more than delayed extents now.  I figured those patches we 
could just merge together sense I dont think your set has been merged yet.

The next step that I am working on now is getting it to track allocated 
extents.  So any pointers for doing that would be helpful :)  It looks 
like the current code is optimized for merging extents as much as 
possible, and that makes sense for delayed extents, but for allocated 
extents, we need to get it to mirror the existing extents.  That way we 
will know what extents there are to lock before we start doing things 
with the current extent tree.

When I think about all the ins and outs of trying to keep the trees in 
sync, I realize it may get complex, but I dont think we would want to 
deal with the odd things that might come out of allowing tasks to lock a 
partial extent either.  Suggestions for simplifications are certainly 
welcome though :)

Thx!
Allison Henderson

