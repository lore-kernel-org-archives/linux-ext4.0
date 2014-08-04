From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH 0/4] quota: add project quota support
Date: Mon, 4 Aug 2014 22:44:29 +0800
Message-ID: <CAPTn0cCyMRE4kWbi390z5Ba8r1-VSN9azKHcmJOnmRPrNd5VoA@mail.gmail.com>
References: <CAPTn0cD3eZgL1FaJLrgN-c_vhsvSoifmyLah=y60ejcAEOz-Mg@mail.gmail.com>
	<20140801201756.GD7525@quack.suse.cz>
	<CAPTn0cDkN_aBZwOVCZjPcJD+8ArKvPmZcE7XHwkDRSjoXhVY+A@mail.gmail.com>
	<20140804140818.GB25770@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36458 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaHDOoa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 10:44:30 -0400
Received: by mail-ie0-f175.google.com with SMTP id x19so10131902ier.34
        for <linux-ext4@vger.kernel.org>; Mon, 04 Aug 2014 07:44:29 -0700 (PDT)
In-Reply-To: <20140804140818.GB25770@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>   Hum, you are right. add_dquot_ref() is an issue. So probably we'll have
> add get_projid() method to struct dquot_operations (similar to
> get_reserved_space() we have there).
>
>> Personally, I perfer to add projid in the inode
>> stucture, since projid looks like uid and gid of an inode.
>> get_projid()/setprojid()
>> looks duplicated with getattr()/setattr() or getxattr()/setxattr(). Is there any
>> performance impact of increasing size of inode structure, e.g. cache
>> line problem?  I will add get_projid() method if so.
>   I agree projid looks like uid or gid. But uid & gid are in POSIX so
> everyone needs them. projid isn't so we'll just waste space for lots of
> inodes (not too much but still some and this way struct inode gets slowly
> bloated and we can have lots of inodes around). And it's not too hard to
> live without project ID in core inode... Once significant portion of
> filesystems start to support project ID, situation is different and we'll
> move project ID into core inode.
>
> Regarding getting & setting project ID from userspace I suppose you'll have
> to resort to fs-specific ioctl like XFS does and then setting project ID in
> fs-specific part of the inode is trivial.
OK. Thank you very much for your detailed advices. I will refresh the patches
soon.

Regards,
Li Xi
