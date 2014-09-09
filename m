From: "Burton, Ross" <ross.burton@intel.com>
Subject: Re: [V4] misc: copy extended attributes in populate_fs
Date: Tue, 9 Sep 2014 11:20:34 +0100
Message-ID: <CAJTo0LYSjRtoN29_VmKv=CxyCJpwaywqfqOegZPFnWbV1+96ow@mail.gmail.com>
References: <1405010678-993-1-git-send-email-ross.burton@intel.com> <20140728012909.GA19632@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:55393 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaIIKUz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2014 06:20:55 -0400
Received: by mail-qc0-f171.google.com with SMTP id x3so17445196qcv.30
        for <linux-ext4@vger.kernel.org>; Tue, 09 Sep 2014 03:20:54 -0700 (PDT)
In-Reply-To: <20140728012909.GA19632@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 28 July 2014 02:29, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 10, 2014 at 05:44:38PM +0100, Ross Burton wrote:
>> When creating a file system using a source directory, also copy any extended
>> attributes that have been set.
>>
>> Signed-off-by: Ross Burton <ross.burton@intel.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> Applied, after I added configure tests to test for the Linux-specific
> system calls, and to add a fallback in case we are compiling on a
> non-Linux system.

Thanks Ted.

I see that you merged before 1.42.12 was released but this didn't make
1.42.12.  Will it be in 1.42.13, or is it waiting for a 1.43.0
release?

Cheers
Ross
