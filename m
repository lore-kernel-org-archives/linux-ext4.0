From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC v1 0/5]Factor common code from convert and split unwritten.
Date: Tue, 26 Apr 2011 23:34:31 -0700
Message-ID: <4DB7B8F7.9020306@linux.vnet.ibm.com>
References: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com> <4DB71844.5030103@linux.vnet.ibm.com> <BANLkTi=7VsvPGztFtAOFh5trGZ0dHH7rWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39438 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab1D0Gep (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Apr 2011 02:34:45 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3R6AL84023470
	for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2011 02:10:21 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3R6YYfq1212580
	for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2011 02:34:34 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3R6YXOE002804
	for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2011 02:34:34 -0400
In-Reply-To: <BANLkTi=7VsvPGztFtAOFh5trGZ0dHH7rWQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/26/2011 9:48 PM, Yongqiang Yang wrote:
> On Wed, Apr 27, 2011 at 3:08 AM, Allison Henderson
> <achender@linux.vnet.ibm.com>  wrote:
>> On 4/23/2011 1:44 AM, Yongqiang Yang wrote:
>>>
>>> v0->v1:
>>>     fix a bug in ext4_ext_convert_to_initialized() reported by
>>>     Allison<achender@linux.vnet.ibm.com>.
>>>
>>>     optimize ext4_ext_convert_to_initialized().
>>>
>>> -- factor common code
>>>     These patches factor common code from ext4_ext_convert_to_initialized()
>>> and
>>>     ext4_split_unwritten_extents() so that extent-move-on-write in snapshot
>>> and
>>>     punch hole can be built on the common code.
>>>
>>> -- optimization
>>>     the 4th and the 5th patch optimize ext4_ext_convert_to_initialized() by
>>>     zeroing out in memory.
>>>
>>>
>>> [PATCH RFC v1 1/5] ext4:Add a function merging extent right and left.
>>> [PATCH RFC v1 2/5] ext4:Add two functions splitting an extent.
>>> [PATCH RFC v1 3/5] ext4:Reimplement convert and split_unwritten.
>>> [PATCH RFC v1 4/5] ext4: Add a function ext4_ext_zeroout_mem().
>>> [PATCH RFC v1 5/5] ext4: optimize ext4_ext_convert_to_initialized().
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> Hi there,
>>
>> Just an update on your patch set.  Im am working on getting the punch hole
>> patch to work with this new set, but I'm am having trouble getting it
>> through the stress test.  It gets up to around 48265 file operations, and
>> then hangs. So I am currently trying to narrow down the problem.  It looks
>> like it does it with or with out the extra punch hole patches, but you may
>> need to enable fallocate in the fsx Makefile to recreate the problem.  I
>> will keep you posted if I find any more clues.
> Hi,
>
> Could you tell me how to get fsx?  I can not find that.

Hi there,

I believe you can find it in both xfstests and ltp.  The one I am using 
I got from xfstests here:

http://xfs.org/index.php/Getting_the_latest_source_code

Once you have it configured and built, there is a sub folder called ltp. 
  Execute this command from that folder:

./fsx -d -b 1 -N 100000 -S 1 /mnt/ext4MntPt/holePunch/testFile

Where "/mnt/ext4MntPt/holePunch/testFile" is a file on an ext4 file 
system.  It should then try to run through 100000 random file 
operations, but get stuck on number 48256.

If you do not see any fallocate operations running, you may have to go 
enable it in the ltp/Makefile.  I had to change "ifeq 
($(HAVE_FALLOCATE), true)" to "ifeq ($(HAVE_FALLOCATE), yes)" to allow 
the extra fallocate code to compile in.  Let me know if you have any 
trouble recreating the bug.

>
> Thank you,
> Yongqiang.
>>
>> Allison Henderson
>>
>
>
>

