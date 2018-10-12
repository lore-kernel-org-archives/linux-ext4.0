Return-Path: <SRS0=yq1P=MY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48598 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbeJLXC1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Oct 2018 19:02:27 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND v2 00/25] Ext4 Encoding and Case-insensitive support
References: <20180924215655.3676-1-krisman@collabora.co.uk>
        <20181011222359.GB24824@magnolia>
Date: Fri, 12 Oct 2018 11:29:23 -0400
In-Reply-To: <20181011222359.GB24824@magnolia> (Darrick J. Wong's message of
        "Thu, 11 Oct 2018 15:23:59 -0700")
Message-ID: <87bm7zi3os.fsf@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> Yep.  This probably needs a _require_unnormalized_dnames() helper to
> detect when filename normalization is happening.  IIRC this test also
> fails on HFS+, as expected.

Hey Darrick,

Yes, I patched my xfstests locally, but only for ext4.  I Will include
this test in a more generic manner when submitting the
xfstests patches.

> Do you normalize attr names?  I surmise not since you didn't complain
> about generic/454.
>


No, I'm not normalizing attr names.


>> We also developed encoding and casefolding tests for xfstests, allowing
>> us to quickly verify the implementation.  I will be sumitting them
>> upstream too, but for now they are available at:
>> 
>>   https://gitlab.collabora.com/krisman/xfstests.git -b encoding
>
> Er... those common/encoding helpers are going to have to deal with other
> filesystems. :)
>> These tests validate the usage on inline dirs, on dx directories, when
>> dealing with dcache and more.  I am happy with the coverage we have now,
>> but if you have specific concerns I can add more tests.
>> 
>> A modified version of e2fsprogs is necessary to run the tests, and to
>> enable the feature.  Support for mkfs, fsck, lsattr, chattr is
>> available.  I also hacked tune2fs to prevent it from setting the
>> encryption flag when encoding is enabled.  This tune2fs change is
>> temporary until we are able to support these two features together.
>> 
>>   https://gitlab.collabora.com/krisman/e2fsprogs.git -b encoding-feature
>> 
>> Gabriel Krisman Bertazi (21):
>>   nls: Wrap uni2char/char2uni callers
>>   nls: Wrap charset field access
>>   nls: Wrap charset hooks in ops structure
>>   nls: Split default charset from NLS core
>>   nls: Split struct nls_charset from struct nls_table
>>   nls: Add support for multiple versions of an encoding
>>   nls: Implement NLS_STRICT_MODE flag
>>   nls: Let charsets define the behavior of tolower/toupper
>>   nls: Add new interface for string comparisons
>>   nls: Add optional normalization and casefold hooks
>>   nls: ascii: Support validation and normalization operations
>>   nls: utf8: Move nls-utf8{,-core}.c
>>   nls: utf8: Integrate utf8 normalization code with utf8 charset
>>   nls: utf8: Introduce test module for normalized utf8 implementation
>>   vfs: Handle case-exact lookup in d_add_ci
>>   ext4: Include encoding information in the superblock
>>   ext4: Add encoding mount options
>>   ext4: Support encoding-aware file name lookups
>>   ext4: Implement encoding-aware dcache hooks
>>   ext4: Implement EXT4_CASEFOLD_FL flag
>>   docs: ext4.rst: Document encoding and case-insensitive lookups
>> 
>> Olaf Weber (4):
>>   nls: utf8n: Add unicode character database files
>>   scripts: add trie generator for UTF-8
>>   nls: utf8: Introduce code for UTF-8 normalization
>>   nls: utf8n: reduce the size of utf8data[]
>> 
>>  Documentation/filesystems/ext4/ext4.rst |   38 +
>>  fs/befs/linuxvfs.c                      |    8 +-
>>  fs/cifs/cifs_unicode.c                  |   15 +-
>>  fs/cifs/cifsfs.c                        |    2 +-
>>  fs/cifs/connect.c                       |    2 +-
>>  fs/cifs/dir.c                           |    7 +-
>>  fs/dcache.c                             |   33 +-
>>  fs/ext4/dir.c                           |   59 +
>>  fs/ext4/ext4.h                          |   33 +-
>>  fs/ext4/hash.c                          |   38 +-
>>  fs/ext4/ialloc.c                        |    2 +-
>>  fs/ext4/inline.c                        |    2 +-
>>  fs/ext4/inode.c                         |    4 +-
>>  fs/ext4/ioctl.c                         |   18 +
>>  fs/ext4/namei.c                         |   99 +-
>>  fs/ext4/super.c                         |  170 ++
>>  fs/fat/dir.c                            |   13 +-
>>  fs/fat/inode.c                          |    6 +-
>>  fs/fat/namei_vfat.c                     |    6 +-
>>  fs/hfs/super.c                          |    6 +-
>>  fs/hfs/trans.c                          |    9 +-
>>  fs/hfsplus/options.c                    |    2 +-
>>  fs/hfsplus/unicode.c                    |    6 +-
>>  fs/isofs/inode.c                        |    5 +-
>>  fs/isofs/joliet.c                       |    3 +-
>>  fs/jfs/jfs_unicode.c                    |    9 +-
>>  fs/jfs/super.c                          |    3 +-
>>  fs/nls/Kconfig                          |   15 +
>>  fs/nls/Makefile                         |   20 +
>>  fs/nls/mac-celtic.c                     |   34 +-
>>  fs/nls/mac-centeuro.c                   |   34 +-
>>  fs/nls/mac-croatian.c                   |   34 +-
>>  fs/nls/mac-cyrillic.c                   |   34 +-
>>  fs/nls/mac-gaelic.c                     |   34 +-
>>  fs/nls/mac-greek.c                      |   34 +-
>>  fs/nls/mac-iceland.c                    |   34 +-
>>  fs/nls/mac-inuit.c                      |   34 +-
>>  fs/nls/mac-roman.c                      |   34 +-
>>  fs/nls/mac-romanian.c                   |   34 +-
>>  fs/nls/mac-turkish.c                    |   34 +-
>>  fs/nls/nls_ascii.c                      |   84 +-
>>  fs/nls/nls_core.c                       |  163 ++
>>  fs/nls/nls_cp1250.c                     |   34 +-
>>  fs/nls/nls_cp1251.c                     |   34 +-
>>  fs/nls/nls_cp1255.c                     |   36 +-
>>  fs/nls/nls_cp437.c                      |   34 +-
>>  fs/nls/nls_cp737.c                      |   34 +-
>>  fs/nls/nls_cp775.c                      |   34 +-
>>  fs/nls/nls_cp850.c                      |   34 +-
>>  fs/nls/nls_cp852.c                      |   34 +-
>>  fs/nls/nls_cp855.c                      |   34 +-
>>  fs/nls/nls_cp857.c                      |   34 +-
>>  fs/nls/nls_cp860.c                      |   34 +-
>>  fs/nls/nls_cp861.c                      |   34 +-
>>  fs/nls/nls_cp862.c                      |   34 +-
>>  fs/nls/nls_cp863.c                      |   34 +-
>>  fs/nls/nls_cp864.c                      |   34 +-
>>  fs/nls/nls_cp865.c                      |   34 +-
>>  fs/nls/nls_cp866.c                      |   34 +-
>>  fs/nls/nls_cp869.c                      |   34 +-
>>  fs/nls/nls_cp874.c                      |   36 +-
>>  fs/nls/nls_cp932.c                      |   36 +-
>>  fs/nls/nls_cp936.c                      |   36 +-
>>  fs/nls/nls_cp949.c                      |   36 +-
>>  fs/nls/nls_cp950.c                      |   36 +-
>>  fs/nls/{nls_base.c => nls_default.c}    |  124 +-
>>  fs/nls/nls_euc-jp.c                     |   29 +-
>>  fs/nls/nls_iso8859-1.c                  |   34 +-
>>  fs/nls/nls_iso8859-13.c                 |   34 +-
>>  fs/nls/nls_iso8859-14.c                 |   34 +-
>>  fs/nls/nls_iso8859-15.c                 |   34 +-
>>  fs/nls/nls_iso8859-2.c                  |   34 +-
>>  fs/nls/nls_iso8859-3.c                  |   34 +-
>>  fs/nls/nls_iso8859-4.c                  |   34 +-
>>  fs/nls/nls_iso8859-5.c                  |   34 +-
>>  fs/nls/nls_iso8859-6.c                  |   34 +-
>>  fs/nls/nls_iso8859-7.c                  |   34 +-
>>  fs/nls/nls_iso8859-9.c                  |   34 +-
>>  fs/nls/nls_koi8-r.c                     |   34 +-
>>  fs/nls/nls_koi8-ru.c                    |   30 +-
>>  fs/nls/nls_koi8-u.c                     |   34 +-
>>  fs/nls/nls_utf8-core.c                  |  333 +++
>>  fs/nls/nls_utf8-norm.c                  |  797 ++++++
>>  fs/nls/nls_utf8-selftest.c              |  307 ++
>>  fs/nls/nls_utf8.c                       |   67 -
>>  fs/nls/ucd/README                       |   33 +
>>  fs/nls/utf8n.h                          |  117 +
>>  fs/ntfs/inode.c                         |    2 +-
>>  fs/ntfs/super.c                         |    6 +-
>>  fs/ntfs/unistr.c                        |   13 +-
>>  fs/udf/super.c                          |    3 +-
>>  fs/udf/unicode.c                        |    4 +-
>>  include/linux/fs.h                      |    2 +
>>  include/linux/nls.h                     |  293 +-
>>  scripts/Makefile                        |    1 +
>>  scripts/mkutf8data.c                    | 3464 +++++++++++++++++++++++
>>  96 files changed, 7482 insertions(+), 633 deletions(-)
>>  create mode 100644 fs/nls/nls_core.c
>>  rename fs/nls/{nls_base.c => nls_default.c} (89%)
>>  create mode 100644 fs/nls/nls_utf8-core.c
>>  create mode 100644 fs/nls/nls_utf8-norm.c
>>  create mode 100644 fs/nls/nls_utf8-selftest.c
>>  delete mode 100644 fs/nls/nls_utf8.c
>>  create mode 100644 fs/nls/ucd/README
>>  create mode 100644 fs/nls/utf8n.h
>>  create mode 100644 scripts/mkutf8data.c
>> 
>> -- 
>> 2.19.0
>> 

-- 
Gabriel Krisman Bertazi
