From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH-e2fsprogs] filefrag: accept positive ioctl return value
Date: Wed, 3 Jun 2009 01:10:17 +0800
Message-ID: <6149e97b0906021010u60892ab9ta1cba067fdcc5086@mail.gmail.com>
References: <1243944761-18673-1-git-send-email-bergwolf@gmail.com>
	 <20090602124017.GS31943@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:39562 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZFBRKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jun 2009 13:10:15 -0400
Received: by pzk7 with SMTP id 7so6827654pzk.33
        for <linux-ext4@vger.kernel.org>; Tue, 02 Jun 2009 10:10:17 -0700 (PDT)
In-Reply-To: <20090602124017.GS31943@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 2, 2009 at 8:40 PM, Theodore Tso <tytso@mit.edu> wrote:
> What does the positive fiemap ioctl return mean? =C2=A0It's not docum=
ented
> in Documentation/filesystems/fiemap.txt.
The positive btrfs_fiemap ioctl return comes from
fiemap_fill_next_extent(), which returns 1 to indicate that
user-supplied fm_extents array is full according to
Documentation/filesystems/fiemap.txt.

--=20
Cheers,
Bergwolf
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
