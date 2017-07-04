From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: have ext4_xattr_set_handle() allocate journal
 credits
Date: Tue, 4 Jul 2017 01:48:39 -0400
Message-ID: <20170704054839.y2k2yxcjmh6b5jt4@thunk.org>
References: <20170629005029.13302-1-tahsin@google.com>
 <20170629030618.5101-1-tahsin@google.com>
 <18BC3861-631F-4C45-9043-14E92B3D7922@dilger.ca>
 <CAAeU0aMSi0A_jAkzDwP6t_TApBwkjMHydxKXfnoK+ojMSxyC=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAeU0aMSi0A_jAkzDwP6t_TApBwkjMHydxKXfnoK+ojMSxyC=A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 30, 2017 at 12:36:51PM -0700, Tahsin Erdogan wrote:
> > One problem with this approach is that restarting the transaction handle will
> > make the xattr update non-atomic, which could be a real problem for some
> > workloads.  For example, ACLs or SELinux or fscrypt xattrs being added in
> > a separate transaction from file creation, or being modified (delete in a
> > separate transaction from add) and then lost completely if the system crashes
> > before the second transaction is committed.
> 
> Agreed.

I really don't like this patch for this reason.

In fact, it doesn't work because in your example code path:

> An example code path is this:
> 
> ext4_mkdir()
>   ext4_new_inode_start_handle()
>     __ext4_new_inode()   <<== transaction handle is started here
>       ext4_init_acl()
>         __ext4_set_acl()
>           ext4_xattr_set_handle()
> 
> In this case, __ext4_new_inode() needs to figure out all journal
> credits needed including the ones for ext4_xattr_set_handle(). This is
> a few levels deep so reaching out to ext4_xattr_set_credits() with the
> right parameters is where the complexity lies.

If we need to restart a transaction in ext4_init_acl(), we will end up
breaking up a transaction into two pieces.  Which means if we crash,
we could very easily end up with a corrupt file system because the
inode might be allocated, but not yet linked into the directory
hierarchy.

Worse, it doesn't really solve the problem because
ext4_xattr_ensure_credits() merely makes sure there are enough credits
for the xattr operation.  If setting the xattr ACL chews up credits
needed to insert the name of the newly created file into the
directory, you're still going to end up running into problems.

The way we've historically handled this is to simplify things by
making worse-case estimates when the transaction handled started.  So
for example, we assume the worst case that we'll split an directory
hash tree, even though we might not know whether or not this will be
necessary.  That's because if we over-estimate the number of credits
needed for a handle, it's really not a disaster.  Most handles are
active for a very short time, and when we close the handle, we can
give back any unused credits.

I understand that for ext4_new_inode it can be quite tricky, since in
theory we might need to add an SE Linux label, plus an ACL, plus an
encryption context.

The one good news is that is that with the xattr inode deduplication
feature, ext4_init_acl as called from ext4_new_inode should always
require just bumping a refcount, since the ACL will be inherited from
the directory's default ACL.

The bad news is that in general, we don't know what
security_inode_init_security() will do.  In theory, it could try to
set an arbitrarily large lael, although in practice we know the SE
Linux label tends not to be too terribly large.

Are you aware of other cases where we're likely to run into problems
besides ext4_new_inode()?

						- Ted
						
