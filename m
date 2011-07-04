From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Mon, 04 Jul 2011 12:09:04 -0700
Message-ID: <4E120FD0.70003@linux.vnet.ibm.com>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com> <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com> <CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com> <E9840366-F572-48CA-B71F-D9AF5E11EBCC@dilger.ca> <CAOQ4uxj26t=Z6mssXZ3dY7=yd8_upuy7-ZMpHrsCbQczp7O0Og@mail.gmail.com> <4E11F61C.6070100@linux.vnet.ibm.com> <CAOQ4uxjwHeP3DqgbW2mJ8wBi=HBcDd-UTaZ=XTsSAcH+jdNvJQ@mail.gmail.com> <9EC28987-9A72-4753-8822-A138C5F0E622@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Amir Goldstein <amir73il@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:49941 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1GDTJL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jul 2011 15:09:11 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p64J66YV016622
	for <linux-ext4@vger.kernel.org>; Mon, 4 Jul 2011 13:06:06 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p64J97i3104830
	for <linux-ext4@vger.kernel.org>; Mon, 4 Jul 2011 13:09:07 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p64D96Mq025364
	for <linux-ext4@vger.kernel.org>; Mon, 4 Jul 2011 07:09:06 -0600
In-Reply-To: <9EC28987-9A72-4753-8822-A138C5F0E622@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/04/2011 11:19 AM, Andreas Dilger wrote:
> On 2011-07-04, at 11:44 AM, Amir Goldstein wrote:
>> On Mon, Jul 4, 2011 at 8:19 PM, Allison Henderson
>> <achender@linux.vnet.ibm.com>  wrote:
>>>
>>> Thx all for the reviews!  It sounds like the zero out code is in the right
>>> spot then.  We are thinking about adding an optimization too, where we use
>>> use secure discard instead of the sb_issue_zeroout, but only if the device
>>> supports it.  I was thinking about putting that code some where in the
>>> commit call back because that is where the existing discard code is, but
>>> maybe that's not such a good place to put it then?  What does everyone
>>> think?  Thx!
>>
>> I already stated my opinion about the need for 2-phase secure delete.
>> If you have to choose between security (zeroout pre commit) and the
>> atomicity of the unlink() command (zeroout post commit), then it's
>> a question of policy.
>> Is there any other FS (or OS) that implements secure delete?
>> Perhaps we could follow its semantics.
>
> One thing we did ages ago, before extent-mapped files made unlink so
> fast, was to move the blocks from unlinked files and truncated-to-zero
> files to a delete queue in the main transaction, and then do the unlink
> via a separate thread.
>
> This facility could be resurrected (a version of the patch was posted to
> linux-ext4 at http://www.spinics.net/lists/linux-ext4/msg06178.html) to
> do the block zeroing/discard in the context of the unlink thread.  It
> could be structured so that sync/fsync on the file waits for background
> zeroing to complete, so that apps doing secure delete + fsync will be
> sure that the file is safely erased.  The fsync would be needed for this
> in any case, otherwise even an inline async zero-fill could fail if the
> system crashes before the blocks are actually flushed to disk.
>
> Cheers, Andreas
>
>
Oh alrighty, I will look into that then.  Thx all for your input!  :)

Allison
