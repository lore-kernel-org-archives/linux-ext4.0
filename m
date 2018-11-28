Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wr1-f44.google.com ([209.85.221.44]:35938 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727713AbeK2AaD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Nov 2018 19:30:03 -0500
MIME-Version: 1.0
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net> <vb31df-25g.ln1@banana.localnet>
 <20181128041555.GE31885@thunk.org>
In-Reply-To: <20181128041555.GE31885@thunk.org>
From: Andrey Melnikov <temnota.am@gmail.com>
Date: Wed, 28 Nov 2018 16:28:10 +0300
Message-ID: <CA+PODjrow+vYB8JiGK0LatjkSU4JA9zM+rt2SriNEtfLNfcSaA@mail.gmail.com>
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=D1=81=D1=80, 28 =D0=BD=D0=BE=D1=8F=D0=B1. 2018 =D0=B3. =D0=B2 07:15, Theod=
ore Y. Ts'o <tytso@mit.edu>:
>
> On Wed, Nov 28, 2018 at 03:16:33AM +0300, Andrey Jr. Melnikov wrote:
> > Corrupted inodes - always directory, not touched at least year or
> > more for writing. Something wrong when updating atime?
>
> We're not sure.  The frustrating thing is that it's not reproducing
> for me.  I run extensive regression tests, and I'm using 4.19 on my
> development laptop without notcing any problems.  If I could reproduce
> it, I could debug it, but since I can't, I need to rely on those who
> are seeing the problem to help pinpoint the problem.
>
> I'm trying to figure out common factors from those people who are
> reporting problems.

For me - switching off CONFIG_EXT4_ENCRYPTION helps. machine survive
run updatedb & kernel compile. Switch it back to ON - crashed again:

[  118.204547] EXT4-fs error (device sde2): ext4_iget:4831: inode
#14155777: comm updatedb: bad extra_isize 13898 (inode size 256)
[  118.248928] Aborting journal on device sde2-8.
[  118.272239] EXT4-fs (sde2): Remounting filesystem read-only
[  118.293364] EXT4-fs error (device sde2):
ext4_journal_check_start:61: Detected aborted journal
[  118.315146] EXT4-fs error (device sde2): ext4_iget:4831: inode
#14155778: comm updatedb: bad extra_isize 38198 (inode size 256)
[  118.326760] EXT4-fs error (device sde2): ext4_iget:4831: inode
#14155780: comm updatedb: bad extra_isize 5023 (inode size 256)
[  118.337916] EXT4-fs error (device sde2): ext4_iget:4831: inode
#14155782: comm updatedb: bad extra_isize 44080 (inode size 256)
[  118.349149] EXT4-fs error (device sde2): ext4_iget:4831: inode
#14155784: comm updatedb: bad extra_isize 56093 (inode size 256)
[  118.360336] EXT4-fs error (device sde2): ext4_iget:4831: inode
#14155786: comm updatedb: bad extra_isize 13308 (inode size 256)
[  118.387113] EXT4-fs error (device sde2): ext4_iget:4831: inode
#14155788: comm updatedb: bad extra_isize 38399 (inode size 256)
[  118.422779] EXT4-fs error (device sde2): ext4_iget:4831: inode
#14155790: comm updatedb: bad extra_isize 24014 (inode size 256)
[  118.438124] EXT4-fs error (device sde2): ext4_iget:4831: inode
#14155792: comm updatedb: bad extra_isize 23262 (inode size 256)

CONFIG_SCSI_MQ_DEFAULT=3Dy in both cases.

Any ideas?
