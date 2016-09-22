From: Eric Biggers <ebiggers@google.com>
Subject: Re: Locking rules for fscrypt_operations->set_context()
Date: Wed, 21 Sep 2016 17:14:02 -0700
Message-ID: <20160922001402.GA124993@google.com>
References: <b6073ec6-3826-a4a1-b1ce-48106c012d43@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        David Gstir <david@sigma-star.at>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36051 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753383AbcIVAOK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Sep 2016 20:14:10 -0400
Received: by mail-pf0-f170.google.com with SMTP id q2so24114542pfj.3
        for <linux-ext4@vger.kernel.org>; Wed, 21 Sep 2016 17:14:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <b6073ec6-3826-a4a1-b1ce-48106c012d43@nod.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 20, 2016 at 04:30:06PM +0200, Richard Weinberger wrote:
> Hi!
> 
> To my understanding ->setxattr() is always being called with i_mutex held.
> ->set_context() in ext4 stores the security context using ext4_xattr_set(),
> but the fs crypto framework does not lock the inode itself.
> So, depending on the call path, ext4_xattr_set() is sometimes being
> called with i_mutex held and some times not.
> 
> What are the locking rules for fscrypt_operations and especially ->set_context()?

Hi Richard, this is a great question.  I would like to document somewhere the
semantics of each of the fscrypt_operations, but I am still figuring them out
myself.

With regards to ->set_context(), it is called in two distinct situtations:

  (1) when a user process uses FS_IOC_SET_ENCRYPTION_POLICY to set the
      encryption policy on an empty directory

  (2) when an encryption policy is inherited by a newly created file in an
      encrypted directory

In case (1), I think there needs to be an inode_lock() added.  For ext4 and
f2fs, it looks like setting an xattr without inode_lock() isn't problematic by
itself.  Instead, the problem I see is that fscrypt_process_policy() does
several operations, including the ->empty_dir() check, which aren't guaranteed
to be atomic if the directory inode is not locked with inode_lock().

In case (2), I don't think it matters whether inode_lock() is held, since the
inode is still being initialized and is still "locked" in a different way, in
the I_NEW state.  There are also other xattrs being set in __ext4_new_inode(),
seemingly without inode_lock(), which I *think* is fine.

So I am currently thinking that fscrypt_process_policy() should be fixed to do
inode_lock(), and ->set_context() should be documented as a filesystem internal
operation (not necessarily related to ->setxattr()) that is called on either an
inode_lock()-ed inode or on an I_NEW inode.

Eric
