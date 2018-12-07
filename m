Return-Path: <SRS0=bs/x=OQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38810 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbeLGSlQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Dec 2018 13:41:16 -0500
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
To: Gabriel Krisman Bertazi <krisman@collabora.com>, tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        linux-ext4@vger.kernel.org
References: <20181206230903.30011-1-krisman@collabora.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <87dfd631-ecc0-7d18-26d8-ea6a2ff46286@infradead.org>
Date: Fri, 7 Dec 2018 10:41:10 -0800
MIME-Version: 1.0
In-Reply-To: <20181206230903.30011-1-krisman@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/6/18 3:08 PM, Gabriel Krisman Bertazi wrote:
> Hi,
> 
> [Resending to include fsdevel, as requested by Dave Chinner]
> 
> Following the e2fsprogs changes, these are the corresponding kernel-side
> modifications to support the fname_encoding feature.
> 
> The patches are split in two parts. The fist 14 patches are refactoring
> and improvements to the NLS code, including the utf8 normalization
> support.  The final patches implement the fname_encoding feature in ext4.

Hi,

Please include some justification and use case(s) in the patch description.

Thanks.

> To test this feature, you need to use the tip of e2fsprogs branch, which
> already include support for enabling this feature.
> 
> As usual, the ucd files are not included in this email because they are
> too large, and would actually cause the email message to bounce.
> 
> There are two test files for this in a private xfstests branch, that I
> plan to submit upstream once we get this series merged:
> 
>   https://gitlab.collabora.com/krisman/xfstests.git -b encoding_v4
> 
> I also tested this with the xfstests smoke tests using two scenarios:
> (1) a non-encoding TEST_DEV; (2) a utf8 enabled TEST_DEV.  On both
> cases, no unrelated regressions where observed.  With my branch of
> xfstests above, that fixes some related tests, I didn't observe any
> regressions.
> 
> Gabriel Krisman Bertazi (19):
>   nls: Wrap uni2char/char2uni callers
>   nls: Wrap charset field access
>   nls: Wrap charset hooks in ops structure
>   nls: Split default charset from NLS core
>   nls: Split struct nls_charset from struct nls_table
>   nls: Add support for multiple versions of an encoding
>   nls: Implement NLS_STRICT_MODE flag
>   nls: Let charsets define the behavior of tolower/toupper
>   nls: Add new interface for string comparisons
>   nls: Add optional normalization and casefold hooks
>   nls: ascii: Support validation and normalization operations
>   nls: utf8: Move nls-utf8{,-core}.c
>   nls: utf8: Integrate utf8 normalization code with utf8 charset
>   nls: utf8: Introduce test module for normalized utf8 implementation
>   ext4: Reserve superblock fields for encoding information
>   ext4: Include encoding information in the superblock
>   ext4: Support encoding-aware file name lookups
>   ext4: Implement EXT4_CASEFOLD_FL flag
>   docs: ext4.rst: Document encoding and case-insensitive
> 
> Olaf Weber (4):
>   nls: utf8: Add unicode character database files
>   scripts: add trie generator for UTF-8
>   nls: utf8: Introduce code for UTF-8 normalization
>   nls: utf8n: reduce the size of utf8data[]
> 
>  Documentation/admin-guide/ext4.rst   |   29 +
>  fs/befs/linuxvfs.c                   |    8 +-
>  fs/cifs/cifs_unicode.c               |   15 +-
>  fs/cifs/cifsfs.c                     |    2 +-
>  fs/cifs/connect.c                    |    2 +-
>  fs/cifs/dir.c                        |    7 +-
>  fs/ext4/dir.c                        |   59 +
>  fs/ext4/ext4.h                       |   33 +-
>  fs/ext4/hash.c                       |   38 +-
>  fs/ext4/ialloc.c                     |    2 +-
>  fs/ext4/inline.c                     |    2 +-
>  fs/ext4/inode.c                      |    4 +-
>  fs/ext4/ioctl.c                      |   18 +
>  fs/ext4/namei.c                      |   85 +-
>  fs/ext4/super.c                      |   83 +
>  fs/fat/dir.c                         |   13 +-
>  fs/fat/inode.c                       |    6 +-
>  fs/fat/namei_vfat.c                  |    6 +-
>  fs/hfs/super.c                       |    6 +-
>  fs/hfs/trans.c                       |    9 +-
>  fs/hfsplus/options.c                 |    2 +-
>  fs/hfsplus/unicode.c                 |    6 +-
>  fs/isofs/inode.c                     |    5 +-
>  fs/isofs/joliet.c                    |    3 +-
>  fs/jfs/jfs_unicode.c                 |    9 +-
>  fs/jfs/super.c                       |    3 +-
>  fs/nls/Kconfig                       |   15 +
>  fs/nls/Makefile                      |   20 +
>  fs/nls/mac-celtic.c                  |   34 +-
>  fs/nls/mac-centeuro.c                |   34 +-
>  fs/nls/mac-croatian.c                |   34 +-
>  fs/nls/mac-cyrillic.c                |   34 +-
>  fs/nls/mac-gaelic.c                  |   34 +-
>  fs/nls/mac-greek.c                   |   34 +-
>  fs/nls/mac-iceland.c                 |   34 +-
>  fs/nls/mac-inuit.c                   |   34 +-
>  fs/nls/mac-roman.c                   |   34 +-
>  fs/nls/mac-romanian.c                |   34 +-
>  fs/nls/mac-turkish.c                 |   34 +-
>  fs/nls/nls_ascii.c                   |   84 +-
>  fs/nls/nls_core.c                    |  163 ++
>  fs/nls/nls_cp1250.c                  |   34 +-
>  fs/nls/nls_cp1251.c                  |   34 +-
>  fs/nls/nls_cp1255.c                  |   36 +-
>  fs/nls/nls_cp437.c                   |   34 +-
>  fs/nls/nls_cp737.c                   |   34 +-
>  fs/nls/nls_cp775.c                   |   34 +-
>  fs/nls/nls_cp850.c                   |   34 +-
>  fs/nls/nls_cp852.c                   |   34 +-
>  fs/nls/nls_cp855.c                   |   34 +-
>  fs/nls/nls_cp857.c                   |   34 +-
>  fs/nls/nls_cp860.c                   |   34 +-
>  fs/nls/nls_cp861.c                   |   34 +-
>  fs/nls/nls_cp862.c                   |   34 +-
>  fs/nls/nls_cp863.c                   |   34 +-
>  fs/nls/nls_cp864.c                   |   34 +-
>  fs/nls/nls_cp865.c                   |   34 +-
>  fs/nls/nls_cp866.c                   |   34 +-
>  fs/nls/nls_cp869.c                   |   34 +-
>  fs/nls/nls_cp874.c                   |   36 +-
>  fs/nls/nls_cp932.c                   |   36 +-
>  fs/nls/nls_cp936.c                   |   36 +-
>  fs/nls/nls_cp949.c                   |   36 +-
>  fs/nls/nls_cp950.c                   |   36 +-
>  fs/nls/{nls_base.c => nls_default.c} |  124 +-
>  fs/nls/nls_euc-jp.c                  |   29 +-
>  fs/nls/nls_iso8859-1.c               |   34 +-
>  fs/nls/nls_iso8859-13.c              |   34 +-
>  fs/nls/nls_iso8859-14.c              |   34 +-
>  fs/nls/nls_iso8859-15.c              |   34 +-
>  fs/nls/nls_iso8859-2.c               |   34 +-
>  fs/nls/nls_iso8859-3.c               |   34 +-
>  fs/nls/nls_iso8859-4.c               |   34 +-
>  fs/nls/nls_iso8859-5.c               |   34 +-
>  fs/nls/nls_iso8859-6.c               |   34 +-
>  fs/nls/nls_iso8859-7.c               |   34 +-
>  fs/nls/nls_iso8859-9.c               |   34 +-
>  fs/nls/nls_koi8-r.c                  |   34 +-
>  fs/nls/nls_koi8-ru.c                 |   30 +-
>  fs/nls/nls_koi8-u.c                  |   34 +-
>  fs/nls/nls_utf8-core.c               |  328 +++
>  fs/nls/nls_utf8-norm.c               |  797 ++++++
>  fs/nls/nls_utf8-selftest.c           |  316 +++
>  fs/nls/nls_utf8.c                    |   67 -
>  fs/nls/ucd/README                    |   34 +
>  fs/nls/utf8n.h                       |  117 +
>  fs/ntfs/inode.c                      |    2 +-
>  fs/ntfs/super.c                      |    6 +-
>  fs/ntfs/unistr.c                     |   13 +-
>  fs/udf/super.c                       |    3 +-
>  fs/udf/unicode.c                     |    4 +-
>  include/linux/fs.h                   |    2 +
>  include/linux/nls.h                  |  293 ++-
>  scripts/Makefile                     |    1 +
>  scripts/mkutf8data.c                 | 3392 ++++++++++++++++++++++++++
>  95 files changed, 7287 insertions(+), 618 deletions(-)
>  create mode 100644 fs/nls/nls_core.c
>  rename fs/nls/{nls_base.c => nls_default.c} (89%)
>  create mode 100644 fs/nls/nls_utf8-core.c
>  create mode 100644 fs/nls/nls_utf8-norm.c
>  create mode 100644 fs/nls/nls_utf8-selftest.c
>  delete mode 100644 fs/nls/nls_utf8.c
>  create mode 100644 fs/nls/ucd/README
>  create mode 100644 fs/nls/utf8n.h
>  create mode 100644 scripts/mkutf8data.c
> 


-- 
~Randy
