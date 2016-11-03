From: Theodore Ts'o <tytso@mit.edu>
Subject: [RFC] A proposal for adding case insensitive lookups to ext4
Date: Thu, 3 Nov 2016 13:28:42 -0400
Message-ID: <20161103172842.q7avc7rztny3zndd@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: guy@linux.com, jra@google.com, drosen@google.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46596 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758233AbcKCR2s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 3 Nov 2016 13:28:48 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

HTML version (which will get updated in response to comments):

     https://thunk.org/tytso/casei-fs.html


# A proposal for adding case insensitive lookups to ext4

## Theodore Ts'o
## Version 0.10

### Introduction

Over the years there has been a desire to add case insensitive lookups
to ext 2/3/4.  The reason why this hasn't happened is doing it right
is hard.  Unfortunately, the workarounds that people have been using
in the absense of first class support for case insensitive lookups are
slow, and evade all of the problems that make this problem hard
anyway.

Hence, I think it's worthwhile to outline what could be done to allow
ext4 to support case insensitive that would be more efficient and less
hacky than some other solutions (e.g., slow FUSE file systems and
hacky wrapfs-based solutions that are subject to crashes when run
under fsstress).

This proposal does not make any on-disk format changes, but rather
adds a mount option which causes lookups to be case insensitive, while
case would be preserved in the directory entries when they are created
and returned via readdir().

### Changes to be made to ext4

1.  If case-insensitivity is enabled, override the default dcache hash
and compare operations to ones that are case insensitive in ext4's
dcache_operations structure.

2.  In ext4_lookup(), if case insensitivity is enabled, and the
directory lookup does not succeed, fall back to a linear search of the
directory using using a case insensitive compare.  (This is slow, but
it's faster compared to doing this in userspace).

### Limitations

1.  Like all of the FUSE and in-kernel searches, case insensitivity
will be implemented using strcasecmp and tolower().  This implies that
only ASCII case folding will be accepted.  One of the problems of
using Unicode is that it is not a fixed target.  The case folding
algorithm is changing as new scripts are added; if someone wants to
add support for Unicode case folding, it should be added to the
kernel, with someone assigned with the headache of updating the case
folding algorithm when new versions of Unicode are issued.

2.  If the lookup is done using the filename as it is stored in the
directory, lookups will be O(1) if the dir_index (htree) ext4 file
system feature is enabled (which is the default).  It might be
possible to use a case insensitive hash for the htree feature.
However, if we do this, then the hash could be broken by changes to
use Unicode, and if we do implement this with Unicode 8.0.0 support,
the on-disk format could be broken by future Unicode updates.  So
adding support for case O(1) lookups when case is not preserved by the
filename provided by the user is highly unlikely.  (I will note that
none of the kludges commonly in use support Unicode anyway, so this
proposal is no worse than those kludges, and my personal approach is
to exert a very strong Somebody Else's Problem field and hope someone
else comes up with a solution for us.)

3.  Some of the hacky alternatives are also trying to support
Android's "unique" file permissions scheme.  Support for this is out
of scope for this proposal, although I do acknowledge we will need to
come up with a clean way of implementing those permissions-related
requirements before we have a complete, clean, bug-free, upstreamable
solution for Android.
