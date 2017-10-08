From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [FOR STABLE 4.1] ext4 crypto: don't regenerate the per-inode
 encryption key unnecessarily
Date: Sun, 8 Oct 2017 14:52:16 -0700
Message-ID: <20171008215216.GA1602@zzz.localdomain>
References: <20171008180953.rpnxvpggqggc334m@thunk.org>
 <20171008191749.GA26458@zzz.localdomain>
 <20171008203449.ys4sg5xztbzxx6ik@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38715 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdJHVwS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Oct 2017 17:52:18 -0400
Content-Disposition: inline
In-Reply-To: <20171008203449.ys4sg5xztbzxx6ik@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 08, 2017 at 04:34:50PM -0400, Theodore Ts'o wrote:
> 
> At this point, looking at 4.1, I can't really recommend that _anyone_
> try to use ext4 encryption with the 4.1 LTS kernel.  Fortunately, I
> don't think there are that many users of 4.1, and those that do
> probably aren't using ext4 encryption.  (The Android ecosystem seems
> to have largely settled on 3.18 and 4.4, and there hasn't been much
> use of ext4 encryption outside of Android yet.)  I just want to make
> sure keep the latest upstream LTS kernels mostly clean with respect to
> xfstests runs, so I more easily detect regressions.

Yes, I generally haven't been backporting ext4 encryption fixes to 4.1 because
ext4 encryption is very broken in that kernel, the code is only reachable with
CONFIG_EXT4_FS_ENCRYPTION=y, everyone seemed to be using 3.18 or 4.4 instead,
and the ext4 encryption code changed a lot between 4.1 and 4.4.  But yes, it's
nice at least making it so that xfstests doesn't crash the kernel.  We should
probably also backport 9a200d075e5d ("ext4: require encryption feature for
EXT4_IOC_SET_ENCRYPTION_POLICY") so that if someone happens to have
CONFIG_EXT4_FS_ENCRYPTION turned on in their kernel, random unprivileged users
can't reach all the buggy code on any ext4 filesystem.

By the way, just looking at ext4_generate_encryption_key() in 4.1, there are
three different bugs in how it's accessing the keyring, and all allow an
unprivileged user to cause a kernel oops.  The first two were fixed upstream by
687c3c36e754 ("ext4 crypto: replace some BUG_ON()'s with error checks") and
db7730e3091a ("ext4 crypto: add missing locking for keyring_key access").  The
last will be fixed by "fscrypt: fix dereference of NULL user_key_payload" which
still needs to be applied.  (It's part of a series which fixes the same bug in 5
different places; I'll probably need to resend the patches individually to the
different maintainers unless the keyrings maintainer wants to take the whole
series.)

Eric
