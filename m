From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: Re: [PATCH] debugfs: increase inode reference count after link
Date: Sun, 12 Feb 2017 20:35:16 +0300
Message-ID: <CAO3qy=GqsSvx4b=YcFbifDGpbD8pp70wmQj6vRRZ5gtU7Y7DGQ@mail.gmail.com>
References: <CAO3qy=EnXgiYPFDPkksSzGAaYms2KpNgAb55S_=GryJCRyhg5A@mail.gmail.com>
 <20170131034852.snc2xdfo26kg3icg@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:53146 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751313AbdBLRfT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 12 Feb 2017 12:35:19 -0500
Received: from pps.filterd (m0075550.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1CHYLJN011383
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 12:35:19 -0500
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com [209.85.220.198])
        by mx0a-00003501.pphosted.com with ESMTP id 28jmqysk2w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 12:35:18 -0500
Received: by mail-qk0-f198.google.com with SMTP id t84so79844474qke.7
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 09:35:18 -0800 (PST)
In-Reply-To: <20170131034852.snc2xdfo26kg3icg@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Theodore,

Thank you for explanation and sorry I misunderstand "link" command. I
don't want to add "link" version that increase reference count. I
added some stings to "expect" file and expect fsck will warn about
this reference count. This is fine for debug purpose.

Best regares,
Artem Blagodarenko.


On Tue, Jan 31, 2017 at 6:48 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Jan 20, 2017 at 07:53:42PM +0300, Artem Blagodarenko wrote:
>> Inode reference count is not increased after debugfs link command.
>> This leads to inconsistent file system state.
>
> That was deliberate.  Originally the "link" and "unlink" commands were
> designed as a low-level command that didn't change the link count.
> There are *many* commands in debugfs that can lead to inconsistent
> file system state.  In fact, the original raison d'=C3=AAtre of debugfs w=
as
> to create corrupted file systems to test e2fsck.  :-)
>
> The "rm" command is user-friendly command that I added later which
> decrements the link count and deallocates the blocks if the link count
> goes to zero.
>
> I never got around to adding a user-friendly 'ln' command which
> creates the directory entry and also increments the link count.
> That's mainly because no one has really needed or wanted that
> functionality.  Or at least, no one has requested it up until now.
>
> If you really want it, probably the best thing to do would be unalias
> the "link" and "ln" commands, and make the "ln" command the
> user-friendly command that works like the /bin/ln command.
>
> Cheers,
>
>                                                 - Ted



--=20
Artem Blagodarenko Ph.D.=C2=B7 SW Developer on my.seagate.com
Seagate Technology, LLC
www.seagate.com
