From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC 00/13] UTF-8 case insensitive lookups for EXT4
Date: Fri, 12 Jan 2018 05:12:21 -0200
Message-ID: <20180112071234.29470-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@lists.collabora.co.uk, alvaro.soliverez@collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, bpm@sgi.com, olaf@sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

In the past few months, I've been working to support case-insensitive
lookups of utf8 encoded strings, primarily for EXT4, and then for other
filesystems.  This RFC uses the awesome UTF8 normalization
implementation done by the SGI guys in 2014, namely Olaf Weber and Ben
Myers, but it, unfortunately, never went upstream.  That SGI effort was
made of 3 versions of an RFC submitted to this list, and the last
version was archived below:

https://www.spinics.net/lists/xfs/msg30069.html

For normalization support, I basically rebased those patches and
addressed the issues that where raised on the list at that time.  I also
implemented an extension to do some testing of the exported functions in
kernelspace, to make sure we can catch regressions early.  Obviously,
more tests are needed, particularly for Hangul alorithmic decomposition.

Like the original submission from Ben, I excluded the commit that
includes the generated header file and unicode files because they are
too big and would bounce the list.  Instead, instructions on fetching
and generating the files are documented in the commit message.

An important difference to the original SGI patches is that I have
introduced a midlayer API between the low-level normalization code and
the userfilesystem usercode.  The goal is to hide implementation details
behind a more simple interface of strncmp()/strcasecmp()-like functions,
as well as a more specific casefold() operation, which implements the
behavior defined by the unicode spec.  This reduces filesystem changes
to a minimal.  As a quick example, the fs code can load a struct
charset, which is decided by the encoding mount parameter or sb
information and then call the helpers charset_strncmp or
charset_strncasecmp when matching names.

This implementation has an obvious intersection with the NLS code
already in the kernel.  It holds a few differences, though, like
implementing some higher-level functions instead of toupper/tolower
functions, which are not enough for full caseless comparison, and it
also supports versioning of the encoding, which is required to ensure
stability of case-folding operations.  If the community understands we
should merge these changes back to the NLS code, I can work on it, but
it should require some reworking on how the NLS system is implemented.

The charsets code doesn't do any locking on the module or refcounts the
registered encoding modules yet.  I was assuming I would be asked to
merge it into NLS, so I would rather discuss this change first, rather
than polish final details in advance.

The ext4 insensitive-lookup doesn't require any on-disk changes.  It has
a performance hit for huge directories since if the lookup doesn't use
the exact case, we will fallback to linear search.  This is a
performance problem, but it feels acceptable for now.

Right now, with the RFC applied, you can mount an existing ext4
filesystem with:

mount -o encoding=utf8-7.0.0 /dev/sdaX /mnt

And perform lookups of compatible sequences (NKFD), the filesystem
should successfully complete the lookup.  If you add 'ignorecase' as a
mountoption, casefolding will be performed and caseless matching of
compatible sequences should work.

Finally, Thank you Olaf and Ben for your work on the normalization
patches.  I am really looking forward to have your contribuitions
merged, so I'd love to hear people thoughts and suggestions on what is
needed for upstream acceptance.

Gabriel Krisman Bertazi (9):
  charsets: Introduce middle-layer for character encoding
  charsets: ascii: Wrap ascii functions to charsets library
  charsets: utf8: Hook-up utf-8 code to charsets library
  charsets: utf8: Introduce test module for kernel UTF-8 implementation
  ext4: Add ignorecase mount option
  ext4: Include encoding information on the superblock
  fscrypt: Introduce charset-based matching functions
  ext4: Support charset name matching
  ext4: Implement ext4 dcache hooks for custom charsets

Olaf Weber (4):
  charsets: utf8: Add unicode character database files
  scripts: add trie generator for UTF-8
  charsets: utf8: Introduce code for UTF-8 normalization
  charsets: utf8: reduce the size of utf8data[]

 fs/ext4/dir.c                   |   63 +
 fs/ext4/ext4.h                  |    6 +
 fs/ext4/namei.c                 |   27 +-
 fs/ext4/super.c                 |   35 +
 include/linux/charsets.h        |   73 +
 include/linux/fscrypt.h         |    1 +
 include/linux/fscrypt_notsupp.h |   16 +
 include/linux/fscrypt_supp.h    |   27 +
 include/linux/utf8norm.h        |  116 ++
 lib/Kconfig                     |   16 +
 lib/Makefile                    |    2 +
 lib/charsets/Makefile           |   24 +
 lib/charsets/ascii.c            |   98 ++
 lib/charsets/core.c             |   68 +
 lib/charsets/test_ucd.c         |  186 +++
 lib/charsets/ucd/README         |   33 +
 lib/charsets/utf8_core.c        |  178 ++
 lib/charsets/utf8norm.c         |  794 +++++++++
 scripts/Makefile                |    1 +
 scripts/mkutf8data.c            | 3464 +++++++++++++++++++++++++++++++++++++++
 20 files changed, 5219 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/charsets.h
 create mode 100644 include/linux/utf8norm.h
 create mode 100644 lib/charsets/Makefile
 create mode 100644 lib/charsets/ascii.c
 create mode 100644 lib/charsets/core.c
 create mode 100644 lib/charsets/test_ucd.c
 create mode 100644 lib/charsets/ucd/README
 create mode 100644 lib/charsets/utf8_core.c
 create mode 100644 lib/charsets/utf8norm.c
 create mode 100644 scripts/mkutf8data.c

-- 
2.15.1
