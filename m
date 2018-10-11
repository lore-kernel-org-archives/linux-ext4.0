Return-Path: <SRS0=dqau=MX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40418 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbeJLFx1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Oct 2018 01:53:27 -0400
Date: Thu, 11 Oct 2018 15:23:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND v2 00/25] Ext4 Encoding and Case-insensitive
 support
Message-ID: <20181011222359.GB24824@magnolia>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180924215655.3676-1-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2018 at 05:56:30PM -0400, Gabriel Krisman Bertazi wrote:
> [Resend, but also rebased on top of Ted's dev branch.]
> 
> Hi Ted,
> 
> This patchset implements encoding support as a superblock feature, valid
> for the entire disk, and Case-insensitive lookups support as a
> per-directory feature, configured as an inode flag.  Alongside the
> addition of the casefolding patch, which was not part of v1, I fixed
> some bugs and addressed the concerns raised regarding invalid sequences
> and what normalization we use.
> 
> My approach to solve the two problems above is to make things more
> flexible.  An encoding flags field in the superblock registers what kind
> of normalization is used by the filesystem.  Right now, the only
> encoding supported for utf8 is NFKD, for instance, but if we want to
> support a different normalization function in the future, we can be

Hmmm, I'm curious, why pick NFKD specifically?  AFAICT Linux userspace
environments (I only tried with GNOME and KDE) use NF[K]C.  I saved a
file with the name "café.txt" (c-a-f-compose-e-'-dot-t-x-t), and this is
what the ls output looked like:

$ /bin/ls café.txt | od -tx1 -Ad -c
0000000  63  61  66  c3  a9  2e  74  78  74  0a
          c   a   f 303 251   .   t   x   t  \n
0000010

and xfs_db confirms that's what's in the file name:

# xfs_db /tmp/a.img
xfs_db> sb 0
xfs_db> addr rootino
xfs_db> p u3.sfdir3
u3.sfdir3.hdr.count = 1
u3.sfdir3.hdr.i8count = 0
u3.sfdir3.hdr.parent.i4 = 128
u3.sfdir3.list[0].namelen = 9
u3.sfdir3.list[0].offset = 0x60
u3.sfdir3.list[0].name = "caf\303\251.txt"
u3.sfdir3.list[0].inumber.i4 = 131
u3.sfdir3.list[0].filetype = 1

Is there a particular reason you picked NFKD?  Ohhh, right, because this
series is a derivative of the ~2014 XFS case folding patchset.  Hmm, so
looking at the ext4 changes, I guess what you do is add a custom ->d_hash
function so that the dentries are hashed by hash(nfkd(fname))?  Which
makes it easy to have link() look for names that will conflict after
normalization?  Which I guess is also how casefolding happens for
lookups?  And I suppose that's why the superblock also has to store the
version of Unicode used and the folding options?  Hmm, ok, sounds
reasonable to me so far.

> backward compatible.  Likewise, superblock flags also define the
> behavior when dealing with invalid sequences.  The default behavior is
> to just treat invalid sequences as opaque byte sequences, falling back
> to the original behavior. Alternatively if the strict flag is enabled,
> the kernel will reject invalid sequences as soon as they are detected.
> All these flags, can only be set at mkfs time, using the encoding_flags
> parameter.
> 
> Each encoding has its default flags, when creating the filesystem in
> mkfs, regarding normalization/casefold functions and how to deal with
> opaque sequences.
> 
> The NLS patches implement generic casefold and normalization operation
> (defined as tolower() and identity(), respectively), allowing us to use
> any NLS charset in the kernel.  We store the NLS charset as a magic
> number in the superblock, and for that only a few charsets are defined.
> If you want to force a different charset, the encoding and
> encoding_flags mount options are also provided.
> 
> This patchset also includes the NLS changes that I am proposing,
> including the entire utf8 normalization implementation.  Differently
> from the previous version, I merged utf8 and utf8n, allowing the user to
> request a specific normalization (or no normalization at all) using the
> flags. As usual, I did not include the source ucd files because they
> would bounce in the list, but a completely functional implementation can
> be found at:
> 
>   https://gitlab.collabora.com/krisman/linux.git -b ext4-ci-directory
> 
> I am also not supporting encoding with encrypted directories, given the
> cost of searching encrypted directories where the diggested name is not
> normalized. This means that we need to decrypt each filename beforehand,
> so I decided to simply skip this for now.  If the user tries to mount
> with encoding a directory that has the encryption feature, we simply
> bail out saying it is not supported.
> 
> The patchset survives without failures the smoke tests of xfstests, with
> the obvious exception of generic/453.  This test, which verifies that
> multiple files having equivalent names (which would match in utf8
> normalization) are not the same file, doesn't really make sense with
> this patchset, since it basically verifies the fs is *not* encoding
> aware.

Yep.  This probably needs a _require_unnormalized_dnames() helper to
detect when filename normalization is happening.  IIRC this test also
fails on HFS+, as expected.

Do you normalize attr names?  I surmise not since you didn't complain
about generic/454.

> We also developed encoding and casefolding tests for xfstests, allowing
> us to quickly verify the implementation.  I will be sumitting them
> upstream too, but for now they are available at:
> 
>   https://gitlab.collabora.com/krisman/xfstests.git -b encoding

Er... those common/encoding helpers are going to have to deal with other
filesystems. :)

> These tests validate the usage on inline dirs, on dx directories, when
> dealing with dcache and more.  I am happy with the coverage we have now,
> but if you have specific concerns I can add more tests.
> 
> A modified version of e2fsprogs is necessary to run the tests, and to
> enable the feature.  Support for mkfs, fsck, lsattr, chattr is
> available.  I also hacked tune2fs to prevent it from setting the
> encryption flag when encoding is enabled.  This tune2fs change is
> temporary until we are able to support these two features together.
> 
>   https://gitlab.collabora.com/krisman/e2fsprogs.git -b encoding-feature
> 
> Gabriel Krisman Bertazi (21):
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
>   vfs: Handle case-exact lookup in d_add_ci
>   ext4: Include encoding information in the superblock
>   ext4: Add encoding mount options
>   ext4: Support encoding-aware file name lookups
>   ext4: Implement encoding-aware dcache hooks
>   ext4: Implement EXT4_CASEFOLD_FL flag
>   docs: ext4.rst: Document encoding and case-insensitive lookups
> 
> Olaf Weber (4):
>   nls: utf8n: Add unicode character database files
>   scripts: add trie generator for UTF-8
>   nls: utf8: Introduce code for UTF-8 normalization
>   nls: utf8n: reduce the size of utf8data[]
> 
>  Documentation/filesystems/ext4/ext4.rst |   38 +
>  fs/befs/linuxvfs.c                      |    8 +-
>  fs/cifs/cifs_unicode.c                  |   15 +-
>  fs/cifs/cifsfs.c                        |    2 +-
>  fs/cifs/connect.c                       |    2 +-
>  fs/cifs/dir.c                           |    7 +-
>  fs/dcache.c                             |   33 +-
>  fs/ext4/dir.c                           |   59 +
>  fs/ext4/ext4.h                          |   33 +-
>  fs/ext4/hash.c                          |   38 +-
>  fs/ext4/ialloc.c                        |    2 +-
>  fs/ext4/inline.c                        |    2 +-
>  fs/ext4/inode.c                         |    4 +-
>  fs/ext4/ioctl.c                         |   18 +
>  fs/ext4/namei.c                         |   99 +-
>  fs/ext4/super.c                         |  170 ++
>  fs/fat/dir.c                            |   13 +-
>  fs/fat/inode.c                          |    6 +-
>  fs/fat/namei_vfat.c                     |    6 +-
>  fs/hfs/super.c                          |    6 +-
>  fs/hfs/trans.c                          |    9 +-
>  fs/hfsplus/options.c                    |    2 +-
>  fs/hfsplus/unicode.c                    |    6 +-
>  fs/isofs/inode.c                        |    5 +-
>  fs/isofs/joliet.c                       |    3 +-
>  fs/jfs/jfs_unicode.c                    |    9 +-
>  fs/jfs/super.c                          |    3 +-
>  fs/nls/Kconfig                          |   15 +
>  fs/nls/Makefile                         |   20 +
>  fs/nls/mac-celtic.c                     |   34 +-
>  fs/nls/mac-centeuro.c                   |   34 +-
>  fs/nls/mac-croatian.c                   |   34 +-
>  fs/nls/mac-cyrillic.c                   |   34 +-
>  fs/nls/mac-gaelic.c                     |   34 +-
>  fs/nls/mac-greek.c                      |   34 +-
>  fs/nls/mac-iceland.c                    |   34 +-
>  fs/nls/mac-inuit.c                      |   34 +-
>  fs/nls/mac-roman.c                      |   34 +-
>  fs/nls/mac-romanian.c                   |   34 +-
>  fs/nls/mac-turkish.c                    |   34 +-
>  fs/nls/nls_ascii.c                      |   84 +-
>  fs/nls/nls_core.c                       |  163 ++
>  fs/nls/nls_cp1250.c                     |   34 +-
>  fs/nls/nls_cp1251.c                     |   34 +-
>  fs/nls/nls_cp1255.c                     |   36 +-
>  fs/nls/nls_cp437.c                      |   34 +-
>  fs/nls/nls_cp737.c                      |   34 +-
>  fs/nls/nls_cp775.c                      |   34 +-
>  fs/nls/nls_cp850.c                      |   34 +-
>  fs/nls/nls_cp852.c                      |   34 +-
>  fs/nls/nls_cp855.c                      |   34 +-
>  fs/nls/nls_cp857.c                      |   34 +-
>  fs/nls/nls_cp860.c                      |   34 +-
>  fs/nls/nls_cp861.c                      |   34 +-
>  fs/nls/nls_cp862.c                      |   34 +-
>  fs/nls/nls_cp863.c                      |   34 +-
>  fs/nls/nls_cp864.c                      |   34 +-
>  fs/nls/nls_cp865.c                      |   34 +-
>  fs/nls/nls_cp866.c                      |   34 +-
>  fs/nls/nls_cp869.c                      |   34 +-
>  fs/nls/nls_cp874.c                      |   36 +-
>  fs/nls/nls_cp932.c                      |   36 +-
>  fs/nls/nls_cp936.c                      |   36 +-
>  fs/nls/nls_cp949.c                      |   36 +-
>  fs/nls/nls_cp950.c                      |   36 +-
>  fs/nls/{nls_base.c => nls_default.c}    |  124 +-
>  fs/nls/nls_euc-jp.c                     |   29 +-
>  fs/nls/nls_iso8859-1.c                  |   34 +-
>  fs/nls/nls_iso8859-13.c                 |   34 +-
>  fs/nls/nls_iso8859-14.c                 |   34 +-
>  fs/nls/nls_iso8859-15.c                 |   34 +-
>  fs/nls/nls_iso8859-2.c                  |   34 +-
>  fs/nls/nls_iso8859-3.c                  |   34 +-
>  fs/nls/nls_iso8859-4.c                  |   34 +-
>  fs/nls/nls_iso8859-5.c                  |   34 +-
>  fs/nls/nls_iso8859-6.c                  |   34 +-
>  fs/nls/nls_iso8859-7.c                  |   34 +-
>  fs/nls/nls_iso8859-9.c                  |   34 +-
>  fs/nls/nls_koi8-r.c                     |   34 +-
>  fs/nls/nls_koi8-ru.c                    |   30 +-
>  fs/nls/nls_koi8-u.c                     |   34 +-
>  fs/nls/nls_utf8-core.c                  |  333 +++
>  fs/nls/nls_utf8-norm.c                  |  797 ++++++
>  fs/nls/nls_utf8-selftest.c              |  307 ++
>  fs/nls/nls_utf8.c                       |   67 -
>  fs/nls/ucd/README                       |   33 +
>  fs/nls/utf8n.h                          |  117 +
>  fs/ntfs/inode.c                         |    2 +-
>  fs/ntfs/super.c                         |    6 +-
>  fs/ntfs/unistr.c                        |   13 +-
>  fs/udf/super.c                          |    3 +-
>  fs/udf/unicode.c                        |    4 +-
>  include/linux/fs.h                      |    2 +
>  include/linux/nls.h                     |  293 +-
>  scripts/Makefile                        |    1 +
>  scripts/mkutf8data.c                    | 3464 +++++++++++++++++++++++
>  96 files changed, 7482 insertions(+), 633 deletions(-)
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
> -- 
> 2.19.0
> 
