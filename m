From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: probably bug in block allocator
Date: Mon, 12 Feb 2018 09:14:33 +0300
Message-ID: <6B41BA7B-1BF4-471E-AA3B-D4CEFB7335B8@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Ts'o Theodore <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33234 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeBLGOh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Feb 2018 01:14:37 -0500
Received: by mail-lf0-f48.google.com with SMTP id j193so2940722lfe.0
        for <linux-ext4@vger.kernel.org>; Sun, 11 Feb 2018 22:14:37 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi ext4 developers,

I looked into problem with long time allocations with large FS and found =
a some strange in
commit
commit 40ae3487628235e5f1eb27542cca0cdb6e5dbe16
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Feb 4 15:08:40 2013 -0500

    ext4: optimize mballoc for large allocations
..
it have a chunk
@@ -1884,15 +1884,19 @@ static int ext4_mb_good_group(struct =
ext4_allocation_context *ac,
        case 0:
                BUG_ON(ac->ac_2order =3D=3D 0);

-               if (grp->bb_largest_free_order < ac->ac_2order)
-                       return 0;
-
                /* Avoid using the first bg of a flexgroup for data =
files */
                if ((ac->ac_flags & EXT4_MB_HINT_DATA) &&
                    (flex_size >=3D EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) &&
                    ((group % flex_size) =3D=3D 0))
                        return 0;

+               if ((ac->ac_2order > ac->ac_sb->s_blocksize_bits+1) ||
+                   (free / fragments) >=3D ac->ac_g_ex.fe_len) <<<< (0)
+                       return 1;
+
+               if (grp->bb_largest_free_order < ac->ac_2order)
+                       return 0;
+
                return 1;
        case 1:
                if ((free / fragments) >=3D ac->ac_g_ex.fe_len) (1)


..
ac_g_ex isn=E2=80=99t changed between loops, free/fragments is also =
don=E2=80=99t changed.

i this case loop(1) is useless as same condition as used in loop (0), =
but it=E2=80=99s will eats a some time with large number a group.
In this case - i think loop(1) can be cut and save a some time with =
scanning a groups.

Theo, what you think about that change ?


Alex
