From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: hole punching in ext4
Date: Tue, 22 Jan 2013 17:03:12 -0700
Message-ID: <59CF9743-8837-4279-9B5A-8AD0878BF5F2@dilger.ca>
References: <CAKSyJXfvTFjGMO2ZZPsnSjc_fnUzfs2oMrYf7UQoPvO0=98FxA@mail.gmail.com> <CAKSyJXdbwtOQi==rPZ3nS72bLb9wd0rrmt8RTNPJMUCph-B1Ow@mail.gmail.com> <20130122162009.GB2072@gmail.com> <CAKSyJXew+Sx0AB8HgDZxtOvXyKt8Z_UOe4eG1C=27m2_ubdMVw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Bradley C. Kuszmaul" <kuszmaul@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38149 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab3AWADO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jan 2013 19:03:14 -0500
Received: by mail-pa0-f45.google.com with SMTP id bg2so4358327pad.4
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2013 16:03:14 -0800 (PST)
In-Reply-To: <CAKSyJXew+Sx0AB8HgDZxtOvXyKt8Z_UOe4eG1C=27m2_ubdMVw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-01-22, at 4:50 PM, Bradley C. Kuszmaul wrote:
> Thanks, this has been a very helpful thread.
> 
> How do I determine and control whether a file is extent-based?

You can use "lsattr" on the file, and look for the "e" attribute.

This should be standard for any ext4-formatted filesystem.  For
filesystems upgraded from ext3, you need to "tune2fs -O extents"
to enable this feature.

Cheers, Andreas

> On Tue, Jan 22, 2013 at 11:20 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
>> Ext4 file system supports hole punching.  But until now only extent-based
>> file supports it.  As far as I know, redhat distributions don't support
>> hole punching.  You can find a sample program from e2fsprogs which is in
>> $e2fsprogs/conrib/fallocate.c.  The latest fallocate(1) in util-linux
>> also can be as a demo.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

