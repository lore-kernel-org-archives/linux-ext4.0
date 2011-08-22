From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH v2] ext4: make quota as first class supported feature
Date: Mon, 22 Aug 2011 00:08:06 -0700
Message-ID: <CAGr1F2GkYwzrrwjgmSyX_yxAz8WMxq_qZq_ytYKoRhzELQHndA@mail.gmail.com>
References: <1313780769-21713-1-git-send-email-adityakali@google.com> <0EC4FCD1-1DBB-417C-BE5D-4B39ABD67A56@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f70.google.com ([209.85.210.70]:49165 "EHLO
	mail-pz0-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab1HVHOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Aug 2011 03:14:10 -0400
Received: by pzk37 with SMTP id 37so5061pzk.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 00:14:10 -0700 (PDT)
In-Reply-To: <0EC4FCD1-1DBB-417C-BE5D-4B39ABD67A56@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> 6) With the QUOTA feature set, since the quota inodes are hidden, so=
me of the
>> =C2=A0 utilities from quota-tools will no longer work correctly. Ins=
tead, e2fsprogs
>> =C2=A0 will include support for fixing the quota files.
>
> It would be preferable from a usability point of view to have the exi=
sting quota tools to work with the new quota files instead of having to=
 introduce new quota utilities.
>
> There are a number of ways that this could be facilitated:
> - make the quota files visible to userspace, but immutable
> - add the needed calls to the existing quota tools and use them when =
manipulating quotas on ext4 filesystems with this feature
There are only few operations of the quota tools that depend on
accessing the quota files and, AFAIK, supporting hidden quota files is
already in the works. I believe it is already done for some other
filesystems like ocfs2.

> - add library interfaces for doing the quota changes to libext2fs (or=
 a new very simple library) and have the quota tools link to that inste=
ad of interfacing to the kernel directly
>
I have already sent patches to add a new quota library in e2fsprogs
(this library too is majorly based on the current quota tools). With
this, e2fsck can scan and fix quota files and tune2fs/mke2fs can be
used to turn on/off the new quota feature.

Thanks,
--
Aditya

> Cheers, Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
