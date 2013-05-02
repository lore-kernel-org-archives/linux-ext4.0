From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: imperfect FIEMAP results on btrfs
Date: Thu, 02 May 2013 19:00:14 +0300
Message-ID: <1367510414.32396.90.camel@sauron.fi.intel.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-btrfs@vger.kernel.org,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I have a rather extensive FIEMAP test which works fine on ext4 but fail=
s
on btrfs. I've took a look at one of the failures, and simplified it to
the following:

1. create a 4KiB non-sparse file
2. truncate it to 8KiB
3. truncate it to 4KiB + 1 byte

IOW:

$ dd if=3D/dev/urandom of=3Dfile bs=3D4096 count=3D1
$ truncate -s 8192 file
$ truncate -s 4097 file

Let's assume that the FS block size is 4KiB, as it is returned the
=46IGETBSZ ioctl. These actions result in:

1. the file will have only 1 block mapped on ext4
2. the file will have 2 blocks mapped on btrfs

IOW, on ext4:

$ stat file
  File: =E2=80=98file=E2=80=99
  Size: 4097            Blocks: 8          IO Block: 4096   regular fil=
e

and on btrfs

$ stat file
  File: =E2=80=98file=E2=80=99
  Size: 4097            Blocks: 16         IO Block: 4096   regular fil=
e

Notice 8 vs 16 blocks.

Interesting enough that just creating a 4KiB file and then truncating i=
t
to 4097 bytes works as I expect in btrfs - results in a file with only
the first block mapped.

It looks like ext4 is "perfect" in detecting sparse 4KiB blocks while
btrfs sometimes maps seemingly sparse 4KiB blocks. Is this considered t=
o
be a defect or this is fine since the FS does not probably give any
guarantees WRT mapped and unmapped blocks?

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
