From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypt: fix the test_dummy_encryption mount option
Date: Wed, 28 Dec 2016 19:45:26 -0500
Message-ID: <20161229004526.yoo2tyrqnsx3qpbc@thunk.org>
References: <20161228005147.751-1-tytso@mit.edu>
 <20161228212759.GC8557@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161228212759.GC8557@zzz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 28, 2016 at 03:27:59PM -0600, Eric Biggers wrote:
> This problem would also be fixed by my patch to make the test_dummy_encryption
> encryption keys go through the regular keyring lookup and key derivation paths,
> which IMO is a better solution long-term:
> 
> 	fscrypt / ext4: make test_dummy_encryption require a keyring key
> 
> and corresponding xfstests-bld patch:
> 
> 	xfstests-bld: populate keyring with default key for test_dummy_encryption
> 

My problem with this patch is that it breaks backwards compatibility
with older kernels --- such as the 3.10 and 3.18 kernels currently
shipping today in Android handsets.  So I don't want to make changes
to xfstests-bld that require specific kernel patches which aren't
necesarily available on existing kernels which are in use in
production today.

And it won't necessarily be simple to get your fscrypt/ext4 change
into all of the various Android device kernels, the android-common
kernels, the unreleased device kernels in use at various handset
manufactuers, etc.

I don't know if there are going to be a lot of device handset
manufacturers outside of Google that will be trying to make
xfstests-bld work on Android, or by compiling a device kernel on x86
and then running kvm-xfstests or gce-xfstests as the only easy way to
test an Android kernel --- but if someone from some handset
manufacturer comes up to me and asks me for help debugging ext4
encryption, I'd much rather be able to point them at the standard
kvm-xfstests image and tell them it will work with their device kernel
which was based off of the 3.10 or 3.18 android-common git tree.

Cheers,

						- Ted
