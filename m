From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH] mke2fs: do not change root dir ownership
Date: Mon, 13 May 2013 16:09:51 -0700
Message-ID: <519172BF.5010608@linux.intel.com>
References: <1367875316-3089-1-git-send-email-vapier@gentoo.org> <20130513133731.GC4845@thunk.org> <201305131212.28657.vapier@gentoo.org> <20130513210613.GB20102@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mike Frysinger <vapier@gentoo.org>, linux-ext4@vger.kernel.org,
	Robert Yang <liezhi.yang@windriver.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46254 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab3EMXJz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 May 2013 19:09:55 -0400
In-Reply-To: <20130513210613.GB20102@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 05/13/2013 02:06 PM, Theodore Ts'o wrote:
> On Mon, May 13, 2013 at 12:12:27PM -0400, Mike Frysinger wrote:
>> nifty.  we already have to mount the fs to populate it, so putting a chown in 
>> there isn't a big deal in the current setup.
>>
>> now if only e2fsprogs would integrate the `genext2fs` project :).
> 
> Darren Hart created a shell script which uses debugfs to do all of the
> dirty work, called populate-extfs.sh which I believe Linaro and the
> Yocto project is using instead of genext2fs.
> 
> I'm not entirely sure this the latest version, but so you can get a
> flavor of the script, see:
> 
> http://patches.openembedded.org/patch/45415/
> 
> Darren, if you think the script is pretty stable, I'd be happy to drop
> the latest version of it into the contrib directory of e2fsprogs.

Let me sync with Robert (on Cc) who has been doing the integration to
see what he thinks about that.

We consider the script to be a temporary mechanism. Now that the symlink
support has been added to debugfs, we are working to validate that
everything works via the script. Once complete, the second stage of this
effort is to move some of the logic from debugfs into libe2fs and make
it available to mke2fs as well as debugfs. Then we would want to add the
-i (initial dir) argument I had proposed originally to be able to format
and populate an image in a single step.

I provide that context in case it impacts Mike's plans. Always good to
know what others are planning :-)

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
