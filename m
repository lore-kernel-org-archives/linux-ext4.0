From: Sasha Levin <Alexander.Levin@microsoft.com>
Subject: Re: [PATCH] ext4: protect i_disksize update by i_data_sem in direct
 write path
Date: Fri, 30 Mar 2018 16:16:10 +0000
Message-ID: <DM5PR2101MB103262C4DC678FEC128E851BFBA10@DM5PR2101MB1032.namprd21.prod.outlook.com>
References: <20180312152156.14034-2-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Theodore Ts'o <tytso@mit.edu>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Sasha Levin <Alexander.Levin@microsoft.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180312152156.14034-2-guaneryu@gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi again EXT4 ML!

Here's a mail that would be sent as a result of an autoselection. It
will note the "score" of the patch, and will run the same tests we
do for patches tagged for stable.

As before, please let me know your thoughts on this. Thanks!

=3D=3D=3D

Hi Eryu Guan,

[This is an automated email]

This commit has been processed by the -stable helper bot and determined
to be a high probability candidate for -stable trees. (score: 59.259)

The bot has tested the following trees: v4.15.12, v4.14.29, v4.9.89, v4.4.1=
23, v4.1.50, v3.18.101.

v4.15.12: Build OK!
v4.14.29: Build OK!
v4.9.89: Build OK!
v4.4.123: Failed to apply! Possible dependencies:
    914f82a32d02: ("ext4: refactor direct IO code")
    705965bd6dfa: ("ext4: rename and split get blocks functions")
    ba5843f51d46: ("ext4: use pre-zeroed blocks for DAX page faults")
    c86d8db33a92: ("ext4: implement allocation of pre-zeroed blocks")
    2dcba4781fa3: ("ext4: get rid of EXT4_GET_BLOCKS_NO_LOCK flag")

v4.1.50: Failed to apply! Possible dependencies:
    914f82a32d02: ("ext4: refactor direct IO code")
    705965bd6dfa: ("ext4: rename and split get blocks functions")
    ba5843f51d46: ("ext4: use pre-zeroed blocks for DAX page faults")
    ed923b5776a2: ("ext4: add ext4_get_block_dax()")
    e676a4c19165: ("ext4: use ext4_get_block_write() for DAX")
    11bd1a9ecdd6: ("ext4: huge page fault support")
    e676a4c19165: ("ext4: use ext4_get_block_write() for DAX")
    01a33b4ace68: ("ext4: start transaction before calling into DAX")
    ed923b5776a2: ("ext4: add ext4_get_block_dax()")
    e676a4c19165: ("ext4: use ext4_get_block_write() for DAX")
    11bd1a9ecdd6: ("ext4: huge page fault support")
    11bd1a9ecdd6: ("ext4: huge page fault support")

v3.18.101: Failed to apply! Possible dependencies:
    914f82a32d02: ("ext4: refactor direct IO code")
    6f67376318ab: ("direct_IO: use iov_iter_rw() instead of rw everywhere")
    ef96fdddcd38: ("staging: lustre: lustre: llite: use DIV_ROUND_UP")
    42b1ab979d92: ("9p: get rid of v9fs_direct_file_read()")
    9565a5445240: ("9p: get rid of v9fs_direct_file_write()")
    9abb40830700: ("fs/affs/file.c: add support to O_DIRECT")
    92b20708f9f0: ("fs/affs/file.c: fix direct IO writes beyond EOF")
    9abb40830700: ("fs/affs/file.c: add support to O_DIRECT")
    17f8c842d24a: ("Remove rw from {,__,do_}blockdev_direct_IO()")
    92b20708f9f0: ("fs/affs/file.c: fix direct IO writes beyond EOF")
    9abb40830700: ("fs/affs/file.c: add support to O_DIRECT")
    9abb40830700: ("fs/affs/file.c: add support to O_DIRECT")


EXT4 Specific tests:

v4.15.12 (http://stable-bot.westus2.cloudapp.azure.com/ext4-test2/v4.15.12/=
tests/):
    Tests complete.
v4.14.29 (http://stable-bot.westus2.cloudapp.azure.com/ext4-test2/v4.14.29/=
tests/):
    Tests complete.
v4.9.89 (http://stable-bot.westus2.cloudapp.azure.com/ext4-test2/v4.9.89/te=
sts/):
    Tests complete.

Please let us know if you'd like to have this patch included in a stable tr=
ee.
