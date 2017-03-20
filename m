From: =?utf-8?B?0JHQu9Cw0LPQvtC00LDRgNC10L3QutC+INCQ0YDRgtGR0Lw=?=
        <artem.blagodarenko@gmail.com>
Subject: 64-bit inode number
Date: Mon, 20 Mar 2017 13:22:20 +0300
Message-ID: <0E4E58F6-53E5-4FD0-A00F-910225E04201@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Andreas Dilger <adilger@dilger.ca>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Ts'o Theodore <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36736 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754189AbdCTK3D (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Mar 2017 06:29:03 -0400
Received: by mail-lf0-f65.google.com with SMTP id g70so9756867lfh.3
        for <linux-ext4@vger.kernel.org>; Mon, 20 Mar 2017 03:29:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

This topic was mentioned in "Add largedir feature=E2=80=9D, but need to =
be discussed in separate thread.
Increasing maximum inode count is useful with and without larg_dir. =
There is at least one user who needs 64 bit inode number - Lustre FS.=20

As mentioned, MDS has 0-size files to store some information about =
Lustre FS files. Current MDS disk sizes allow to store large amount of =
such files, but EXT4 limits this number to ~4 billions.=20
Lustre FS has features like DNE to distribute MDS over many targets =
(disks), but disks are used  not effectively. It would be great to have =
ability to store more then  ~4 billions inodes on one
EXT4 file system.

 I know there is dirdata feature that allows to store higher 32 bit of =
inode number in ext4 dirent. As I know, direct was not merged yet =
because of user absence. Quote of Andreas from "Add largedir feature=E2=80=
=9D=20

> Mostly because there hasn't been any interest for it whenever I =
proposed
> merging it in the past. If there is some renewed interest in merging =
it
> I could look into it =E2=80=A6

It looks like Lustre FS requires this feature now.

There is another approach how to solve this problem. It is obvious, but =
require change on disk format. Theodore=E2=80=99s quote from "Add =
largedir feature=E2=80=9D=20

> I can imagine a new feature flag which defines the use a 64-bit inode
> number, but that's more for people who are creating a file system that
> takes advantage of 64-bit block numbers, and they are intending on
> using all of that space to store small (< 4k or < 8k) files.


This is exact Lustre FS MDS example. Many small inodes. If it possible =
to add new feature flag, probably this is the best solution: simple, =
obvious, fast.

Please, help with this questions:
1. Do we need 64 bit number now? (My opinion - we need it)
2. What solution from two above to choose? Another solution?

Thanks.

Artem Blagodarenko
