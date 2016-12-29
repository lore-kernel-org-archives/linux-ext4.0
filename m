From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] fscrypt: fix the test_dummy_encryption mount option
Date: Wed, 28 Dec 2016 19:01:49 -0600
Message-ID: <20161229010149.GA12683@zzz>
References: <20161228005147.751-1-tytso@mit.edu>
 <20161228212759.GC8557@zzz>
 <20161229004526.yoo2tyrqnsx3qpbc@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33572 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbcL2BBy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Dec 2016 20:01:54 -0500
Content-Disposition: inline
In-Reply-To: <20161229004526.yoo2tyrqnsx3qpbc@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 28, 2016 at 07:45:26PM -0500, Theodore Ts'o wrote:
> On Wed, Dec 28, 2016 at 03:27:59PM -0600, Eric Biggers wrote:
> > This problem would also be fixed by my patch to make the test_dummy_encryption
> > encryption keys go through the regular keyring lookup and key derivation paths,
> > which IMO is a better solution long-term:
> > 
> > 	fscrypt / ext4: make test_dummy_encryption require a keyring key
> > 
> > and corresponding xfstests-bld patch:
> > 
> > 	xfstests-bld: populate keyring with default key for test_dummy_encryption
> > 
> 
> My problem with this patch is that it breaks backwards compatibility
> with older kernels --- such as the 3.10 and 3.18 kernels currently
> shipping today in Android handsets.  So I don't want to make changes
> to xfstests-bld that require specific kernel patches which aren't
> necesarily available on existing kernels which are in use in
> production today.
> 
> And it won't necessarily be simple to get your fscrypt/ext4 change
> into all of the various Android device kernels, the android-common
> kernels, the unreleased device kernels in use at various handset
> manufactuers, etc.
> 

Actually the patched xfstests-bld can still test both old and new kernels.
Therefore there would be no need to backport the kernel patch.  The xfstests-bld
patch just adds a key to the keyring, which new kernels will use but old kernels
won't (since when test_dummy_encryption is enabled, old kernels don't look at
the keyring at all).

Granted, there is breakage in the other direction --- the kernel change breaks
the current xfstests-bld --- but that's not really an issue since we can just
update xfstests-bld.

Eric
