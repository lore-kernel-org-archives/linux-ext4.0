From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH] mke2fs: do not change root dir ownership
Date: Tue, 14 May 2013 18:36:59 +0800
Message-ID: <519213CB.4050400@windriver.com>
References: <1367875316-3089-1-git-send-email-vapier@gentoo.org> <20130513133731.GC4845@thunk.org> <201305131212.28657.vapier@gentoo.org> <20130513210613.GB20102@thunk.org> <519172BF.5010608@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Mike Frysinger <vapier@gentoo.org>,
	<linux-ext4@vger.kernel.org>
To: Darren Hart <dvhart@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:52659 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3ENKhT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 May 2013 06:37:19 -0400
In-Reply-To: <519172BF.5010608@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 05/14/2013 07:09 AM, Darren Hart wrote:
>
>
> On 05/13/2013 02:06 PM, Theodore Ts'o wrote:
>> On Mon, May 13, 2013 at 12:12:27PM -0400, Mike Frysinger wrote:
>>> nifty.  we already have to mount the fs to populate it, so putting a chown in
>>> there isn't a big deal in the current setup.
>>>
>>> now if only e2fsprogs would integrate the `genext2fs` project :).
>>
>> Darren Hart created a shell script which uses debugfs to do all of the
>> dirty work, called populate-extfs.sh which I believe Linaro and the
>> Yocto project is using instead of genext2fs.
>>
>> I'm not entirely sure this the latest version, but so you can get a
>> flavor of the script, see:
>>
>> http://patches.openembedded.org/patch/45415/
>>
>> Darren, if you think the script is pretty stable, I'd be happy to drop
>> the latest version of it into the contrib directory of e2fsprogs.
>
> Let me sync with Robert (on Cc) who has been doing the integration to
> see what he thinks about that.
>

Hi Darren, thanks for the info, the recent patches are here:

http://patches.openembedded.org/patch/49409/
http://patches.openembedded.org/patch/49413/
http://patches.openembedded.org/patch/49415/

It seem that they are still not stable enough from the replying of the oe-core
mailing list, and I'm working it.

// Robert

> We consider the script to be a temporary mechanism. Now that the symlink
> support has been added to debugfs, we are working to validate that
> everything works via the script. Once complete, the second stage of this
> effort is to move some of the logic from debugfs into libe2fs and make
> it available to mke2fs as well as debugfs. Then we would want to add the
> -i (initial dir) argument I had proposed originally to be able to format
> and populate an image in a single step.
>
> I provide that context in case it impacts Mike's plans. Always good to
> know what others are planning :-)
>
