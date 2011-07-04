From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Mon, 4 Jul 2011 12:19:00 -0600
Message-ID: <9EC28987-9A72-4753-8822-A138C5F0E622@dilger.ca>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com> <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com> <CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com> <E9840366-F572-48CA-B71F-D9AF5E11EBCC@dilger.ca> <CAOQ4uxj26t=Z6mssXZ3dY7=yd8_upuy7-ZMpHrsCbQczp7O0Og@mail.gmail.com> <4E11F61C.6070100@linux.vnet.ibm.com> <CAOQ4uxjwHeP3DqgbW2mJ8wBi=HBcDd-UTaZ=XTsSAcH+jdNvJQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:20875 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1GDSTF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jul 2011 14:19:05 -0400
In-Reply-To: <CAOQ4uxjwHeP3DqgbW2mJ8wBi=HBcDd-UTaZ=XTsSAcH+jdNvJQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-04, at 11:44 AM, Amir Goldstein wrote:
> On Mon, Jul 4, 2011 at 8:19 PM, Allison Henderson
> <achender@linux.vnet.ibm.com> wrote:
>> 
>> Thx all for the reviews!  It sounds like the zero out code is in the right
>> spot then.  We are thinking about adding an optimization too, where we use
>> use secure discard instead of the sb_issue_zeroout, but only if the device
>> supports it.  I was thinking about putting that code some where in the
>> commit call back because that is where the existing discard code is, but
>> maybe that's not such a good place to put it then?  What does everyone
>> think?  Thx!
> 
> I already stated my opinion about the need for 2-phase secure delete.
> If you have to choose between security (zeroout pre commit) and the
> atomicity of the unlink() command (zeroout post commit), then it's
> a question of policy.
> Is there any other FS (or OS) that implements secure delete?
> Perhaps we could follow its semantics.

One thing we did ages ago, before extent-mapped files made unlink so
fast, was to move the blocks from unlinked files and truncated-to-zero
files to a delete queue in the main transaction, and then do the unlink
via a separate thread.

This facility could be resurrected (a version of the patch was posted to
linux-ext4 at http://www.spinics.net/lists/linux-ext4/msg06178.html) to
do the block zeroing/discard in the context of the unlink thread.  It
could be structured so that sync/fsync on the file waits for background
zeroing to complete, so that apps doing secure delete + fsync will be
sure that the file is safely erased.  The fsync would be needed for this
in any case, otherwise even an inline async zero-fill could fail if the
system crashes before the blocks are actually flushed to disk.

Cheers, Andreas





