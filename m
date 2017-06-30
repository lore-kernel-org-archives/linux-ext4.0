From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH v2] ext4: have ext4_xattr_set_handle() allocate journal credits
Date: Fri, 30 Jun 2017 12:36:51 -0700
Message-ID: <CAAeU0aMSi0A_jAkzDwP6t_TApBwkjMHydxKXfnoK+ojMSxyC=A@mail.gmail.com>
References: <20170629005029.13302-1-tahsin@google.com> <20170629030618.5101-1-tahsin@google.com>
 <18BC3861-631F-4C45-9043-14E92B3D7922@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18BC3861-631F-4C45-9043-14E92B3D7922@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> One problem with this approach is that restarting the transaction handle will
> make the xattr update non-atomic, which could be a real problem for some
> workloads.  For example, ACLs or SELinux or fscrypt xattrs being added in
> a separate transaction from file creation, or being modified (delete in a
> separate transaction from add) and then lost completely if the system crashes
> before the second transaction is committed.

Agreed.

> It isn't clear to me why using the current helper function to precompute the
> required transaction credits doesn't get this right in the first place?  It
> would just need to add the xattr credits to the original journal handle?

An example code path is this:

ext4_mkdir()
  ext4_new_inode_start_handle()
    __ext4_new_inode()   <<== transaction handle is started here
      ext4_init_acl()
        __ext4_set_acl()
          ext4_xattr_set_handle()

In this case, __ext4_new_inode() needs to figure out all journal
credits needed including the ones for ext4_xattr_set_handle(). This is
a few levels deep so reaching out to ext4_xattr_set_credits() with the
right parameters is where the complexity lies.
