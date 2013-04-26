From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] mke2fs: fix force option to create filesystem on mounted device
Date: Fri, 26 Apr 2013 15:45:48 -0600
Message-ID: <4A2A7340-F533-4C6E-B05C-39EC548A3D5F@gmail.com>
References: <510F6B75.6090408@sx.jp.nec.com> <5179C331.7050109@sx.jp.nec.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:63067 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3DZVpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Apr 2013 17:45:52 -0400
Received: by mail-pd0-f182.google.com with SMTP id 14so1100909pdj.27
        for <linux-ext4@vger.kernel.org>; Fri, 26 Apr 2013 14:45:51 -0700 (PDT)
In-Reply-To: <5179C331.7050109@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-04-25, at 5:58 PM, Kazuya Mio wrote:
> 2013/02/04 17:04, Kazuya Mio wrote:
>> According to mke2fs man, we can create a filesystem on the mounted device when -FF option is specified.
>> However, currently we have to specify -F option third to force mke2fs. This patch fixes the problem.
>> 
>> Note that force mke2fs for mounted block device fails because mke2fs opens a device with O_EXCL flag. This work is contradictory to mke2fs man page,  
>> but I'm not sure it should be fixed or not. What do you think?
> 
> Ted, please merge two patches if no problem is found.
> 
> http://patchwork.ozlabs.org/patch/217838/

Out of curiosity, is formatting a mounted filesystem something
that you are actually trying to do, or is this just a case of
trying to make the mke2fs usage consistent with the man page?

As for O_EXCL blocking mke2fs, this was changed by my patch in
commit 732e26b98e5c.  The only reason that this used to work
was because a filesystem might _appear_ to be mounted if /etc/mtab
was stale, but wasn't actually in use by the kernel.  I don't
think there is ANY good reason to allow mke2fs to succeed if the
block device is _actually_ in use.

Since 732e26b98e5c prevents mke2fs from actually formatting an
in-use block device (at least on any modern kernel), I'm OK with
this change, but wanted to understand the reasoning behind this.


> http://patchwork.ozlabs.org/patch/217839/

I don't understand the second patch.  If the user tries to format
the /dev/loop device, then it is a "block device" and not really
a "regular file" (i.e. the user probably knows what is going on).
I don't think it is necessary to include the extra code and checking
in this case.  Do I misunderstand what your patch is doing?

Cheers, Andreas





