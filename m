From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Thu, 20 Jul 2017 00:59:11 +0000
Message-ID: <bug-196405-13602-d9F7HruyL4@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38778 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932164AbdGTA7M (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Jul 2017 20:59:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5572628734
        for <linux-ext4@vger.kernel.org>; Thu, 20 Jul 2017 00:59:12 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #15 from Theodore Tso (tytso@mit.edu) ---
I don't think you need to disable the optimization for all of Linux.  All you
need to do is to disable the optimization if the link count on the directory is
1.    A traditional Unix directory will always have a link count of 2, because
if /mnt/dir is a directory, there will be one hard link for "/mnt/dir", and
another hard link for "/mnt/dir/."   Hence it should be very simple for glibc
to detect the case where the link count is 1 and realize that it shouldn't try
to use the optimization.

There are other Linux file systems which use this same convention.  For
example, directories in /proc:

# stat  /proc/sys/kernel/
  File: /proc/sys/kernel/
  Size: 0               Blocks: 0          IO Block: 1024   directory
Device: 4h/4d   Inode: 10298       Links: 1
   ...                             ^^^^^^^^^

The reason why I thought this was a regression in find is because you said that
code which understood the n_links=1 convention was in the old find code?  
Regardless, this behavior has been around for decades.   I suspect if I checked
a Linux 0.99 kernel, it would show this behavior in procfs.

There are a few things which I think we are getting wrong.  First, the
documentation is not quite right.  It claims that the limit is 65,000
subdirectories, when in fact what dir_nlink does is to exempt the 65,000
maximum number of hard links limitation from applying to subdirectories in a
directory.

Secondly, the ext4 code will silently set the dir_link feature flag if there is
an attempt to create a subdirectory which exceeds the EXT4_MAX_LINK and the
directory is using directory indexing.   There have been times in the past when
ext4 will silently set feature flags, but I believe that's a bad thing to do. 
Back in 2007 is was apparently still tolerated, but I think we should change
things such that if the dir_nlink feature is not enabled, the kernel should
return an error if creating a subdirectory would violate EXT4_MAX_LINK instead
of automagically setting the feature flag.

Finally, allowing tune2fs to clear the dir_nlink flag is not a safe thing to
do.   We could allow it if tune2fs were to scan the whole file system making
sure there are no directories with an i_links_count of 1.  But it's easier to
just disallow it clearing the flag.

I disagree that we should disable dir_nlink in the future.   Old find utilities
apparently had old code that would do the right thing.  The fact that it is not
in ftw is unfortunate, but I will note that ftw will break for Linux's
/proc/sys directories as well, and this behavior has been around for a long,
Long, LONG time.   The fact that glibc was mistaken in assuming the
optimization was always safe for Linux is a glibc bug.  I don't understand why
you resist the suggestion of disabling the optimization iff st_nlinks==1.  
That is a clearly safe thing to do.

As far as other programs who might make the same mistake glibc did, since Posix
does not guarantee that '.' and '..' are implemented as hard links, having an
st_link of 1 for directories is completely allowed by Posix.  (i.e., a Posix
environment which does this is a conforming environment).  Hence, a Strictly
Conforming (or Strictly Portable) Posix application should not be making this
assumption.

The fact that we've gone ten years without anyone noticing or complaining is a
pretty strong indicator to me that this isn't a serious portability problem.

In terms of checking the ext4 code, I think you're confused.  It's always done
what I've described, although how it does the check is a bit confusing.   See
the following in ext4.h:

#define is_dx(dir) (ext4_has_feature_dir_index((dir)->i_sb) && \
                    ext4_test_inode_flag((dir), EXT4_INODE_INDEX))
#define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)

Then see the very beginning of ext4_mkdir() and ext4_inc_count() in
fs/ext4/namei.c.

I believe we should add a check for ext4_has_feature_dir_nlink(), as described
above, but the behavior that ext4 has been exhibiting hasn't changed in a very
long time.  That's why you saw the behavior you did on your old RHEL6 system.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
