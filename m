From: Michael Halcrow <mhalcrow@google.com>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Wed, 5 Oct 2016 11:23:07 -0700
Message-ID: <20161005182307.GA1164@google.com>
References: <20161005170659.GA110549@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Weinberger <richard@nod.at>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Anand Jain <anand.jain@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>
To: David Gstir <david@sigma-star.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33305 "EHLO
        mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754683AbcJESXL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Oct 2016 14:23:11 -0400
Received: by mail-pa0-f54.google.com with SMTP id cd13so84519435pac.0
        for <linux-ext4@vger.kernel.org>; Wed, 05 Oct 2016 11:23:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20161005170659.GA110549@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Eric,
> 
> > On 04.10.2016, at 18:38, Eric Biggers <ebiggers@google.com> wrote:
> > 
> > On Tue, Oct 04, 2016 at 10:46:54AM +0200, Richard Weinberger wrote:
> >>> Also, currently this code *is* only supposed to be used for XTS.
> >>> There's a bug where a specially crafted filesystem can cause
> >>> this code path to be entered with CTS, but I have a patch
> >>> pending in the ext4 tree to fix that.
> >> 
> >> David and I are currently working on UBIFS encryption and we have
> >> to support other cipher modes than XTS. So, keeping fscrypto as
> >> generic as possible would be nice. :-)
> >> 
> > 
> > The problem was that the kernel supported reading a file whose
> > contents was encrypted with CTS, which is only supposed to be used
> > for filenames.  This was inconsistent with
> > FS_IOC_SET_ENCRYPTION_POLICY which currently only allows XTS for
> > contents and CTS for filenames.  So in other words I wanted to
> > eliminate a strange scenario that was not intended to happen and
> > was almost certainly never tested.
> > 
> > Either way, new modes can still be added if there is a good reason
> > to do so.  What new encryption modes are you thinking of adding,
> > would they be for contents or for filenames, and are you thinking
> > they would be offered by all filesystems (ext4 and f2fs too)?
> 
> We currently have one case where our embedded platform is only able
> to do AES-CBC in hardware, not AES-XTS. So switching to AES-CBC for
> file contents would yield far better performance while still being
> "secure enough".

Great to see more interest in file system encryption.  A few thoughts.

I'm concerned about the proliferation of storage encryption code in
the kernel.  Of course, I'm perhaps the worst instigator.  However
what's happening now is that we have several file systems that are
proposing their own encryption, as well as several attempts at support
for hardware encryption.

High-performance random access read/write block storage encryption
with authentication is hard to get right.  The way I see it, the ideal
solution would have these properties:

 * The actual cryptographic transform happens in as few places as
   possible -- preferably one place in software, with a sensible
   vendor-neutral API for defering to hardware.

 * All blocks in the file system, including both file contents and
   file system metadata, are cryptographically protected.

 * Encryption is authenticated and has versioning support to enforce
   consistency and defend against rollback.

 * File systems can select which keys protect which blocks.

 * Authentication of all storage chains back to Secure Boot.

To solve all of these simultaneously, it looks like we'll want to
consider changes to the kernel block API:


diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 436f43f..de3492a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -19,6 +19,20 @@ typedef void (bio_end_io_t) (struct bio *);
 typedef void (bio_destructor_t) (struct bio *);
 
 #ifdef CONFIG_BLOCK
+
+#ifdef CONFIG_BLK_CRYPT
+struct bio_crypt_ctx {
+	unsigned int bc_flags;	/* Indicates union interpretation */
+	union {
+		struct key *bc_key;
+		unsigned int bc_key_type;	/* Implies size */
+		unsigned int bc_key_size;
+	};
+	atomic_t __bc_cnt;	/* Pin count */	
+	u8 bc_key[0];
+};
+#endif
+
 /*
  * main unit of I/O for the block layer and lower layers (ie drivers and
  * stacking drivers)
@@ -81,6 +95,10 @@ struct bio {
 
 	struct bio_set		*bi_pool;
 
+#ifdef CONFIG_BLK_CRYPT
+	struct bio_crypt_ctx	*bi_crypt_ctx;
+#endif
+
 	/*
 	 * We can inline a number of vecs at the end of the bio, to avoid
 	 * double allocations for a small number of bio_vecs. This member


>From here, we can delegate to dm-crypt to perform the block
transformation using the key in the bio.  Or we can defer to the block
storage driver to provision the key into the hardware encryption
element and tag requests to use that key.

This promises to get a big chunk of the file contents encryption logic
out of the file system layer.

If the file system doesn't provide a bi_crypt_ctx, then dm-crypt can
use the default key, which would be shared among all tenants of the
system.  That shared key can potentially be further protected by the
distro by leveraging a secure element like a TPM.

For user-specific file contents -- say, what's in the user's home
directory -- then that can be protected with a key that's only made
available after the user logs in (providing their credentials).  Other
tenants on the same device who can get at the shared key might still
get information like how many files other users have or what the
directory structure is, but at least they can't read the contents of
other users' files.  Meanwhile, the volume is comprehensively
protected against the "left in a taxi" scenario.

> Generally speaking though, it would be great to have encryption
> _and_ authentication for file contents.

Not good enough for me.  I want authenticated encryption for
everything, contents or metadata.

> AEAD modes like GCM or future finalists of the CAESAR competition
> come to mind.

GCM is problematic for block storage, primarily because it's
catastrophic to reuse a key/IV pair.

If you naively use the same key when writing more than 2^32 blocks
with a random IV, you've just stepped into the collision "danger
zone" (per NIST SP 800-38D).  We have a design that involves frequent
encryption key derivation in order to address the collision space
problem.  But that's just one piece of the solution to the whole
problem.

> IIRC the ext4 encryption design document mentions this, but it's
> unclear to me why AES-GCM wasn't used for file contents from the
> beginning. I'd guess it has to do with where to store the
> authentication tag and performance.

Comparatively, that's the easy part.  The hard part is ensuring
*consistency* between the ciphertext and the cryptographic metadata.
If you write out the ciphertext and don't get the IV you used for it
out to storage simultaneously, you've just lost the block.  And
vice-versa.

Then there's the problem of internal consistency.  Supposing you do
manage to get the blocks and their crypto metadata out together,
what's to stop an attacker from punching holes (for example)?  You
need an authenticated dictionary structure at that point, such as a
Merkle tree or an authenticated skiplist.

Now you have an additional data structure to maintain.  And you're
rebalancing a Merkle tree in the midst of modifications, or you're
producing an implementation of ASL in the Linux kernel (which, BTW, my
team does have a prototype for right now).

Once we have a root of an authenticated dictionary, we can look to a
high-performance secure hardware element to sign that root against a
monotonic counter to get rollback protection.

To protect the entire block device, we need the authentication data to
be consistent with the ciphertext at the block level.  So that means
something like copy-on-write or log-structured volume at the dm-
layer.  Right now the best shortcut I've been able to come up starts
with a loopback mount on btrfs.

> Does anybody have details on that?

Hopefully I've been able to shine some light on the reasons why
high-performance random access read/write block storage encryption
with authentication is a harder problem than it looks on the surface.

In the meantime, to address the CBC thing, I'd want to understand what
the hardware is doing exactly.  I wouldn't want the existence of code
that supports CBC in fs/crypto to be interpreted as some sort of
endorsement for using it rather than XTS (when unauthenticated
encryption is for some reason the only viable option) for new storage
encryption applications.

> Thanks,
> David
