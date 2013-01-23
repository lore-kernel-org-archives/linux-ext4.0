From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: hole punching in ext4
Date: Tue, 22 Jan 2013 19:38:38 -0600
Message-ID: <50FF3F1E.30001@redhat.com>
References: <CAKSyJXfvTFjGMO2ZZPsnSjc_fnUzfs2oMrYf7UQoPvO0=98FxA@mail.gmail.com> <CAKSyJXdbwtOQi==rPZ3nS72bLb9wd0rrmt8RTNPJMUCph-B1Ow@mail.gmail.com> <20130122162009.GB2072@gmail.com> <CAKSyJXew+Sx0AB8HgDZxtOvXyKt8Z_UOe4eG1C=27m2_ubdMVw@mail.gmail.com> <59CF9743-8837-4279-9B5A-8AD0878BF5F2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Bradley C. Kuszmaul" <kuszmaul@gmail.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab3AWBjm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2013 20:39:42 -0500
In-Reply-To: <59CF9743-8837-4279-9B5A-8AD0878BF5F2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/22/13 6:03 PM, Andreas Dilger wrote:
> On 2013-01-22, at 4:50 PM, Bradley C. Kuszmaul wrote:
>> Thanks, this has been a very helpful thread.
>>
>> How do I determine and control whether a file is extent-based?
> 
> You can use "lsattr" on the file, and look for the "e" attribute.
> 
> This should be standard for any ext4-formatted filesystem.  For
> filesystems upgraded from ext3, you need to "tune2fs -O extents"
> to enable this feature.

But since it sounds like you might be on RHEL, don't do that.  We don't
test it or support it.  If you want ext4, mkfs.ext4 the device and go
from there.

-Eric

> Cheers, Andreas
> 
>> On Tue, Jan 22, 2013 at 11:20 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
>>> Ext4 file system supports hole punching.  But until now only extent-based
>>> file supports it.  As far as I know, redhat distributions don't support
>>> hole punching.  You can find a sample program from e2fsprogs which is in
>>> $e2fsprogs/conrib/fallocate.c.  The latest fallocate(1) in util-linux
>>> also can be as a demo.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

