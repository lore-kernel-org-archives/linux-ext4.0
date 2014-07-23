From: Michael Halcrow <mhalcrow@google.com>
Subject: Re: [PATCH 0/5] ext4: RFC: Encryption
Date: Wed, 23 Jul 2014 16:01:59 -0700
Message-ID: <CA+POJK2bNKRfHhHeP0d97=jjk2d72gx7wBzKK_zNL5bu-BNOaQ@mail.gmail.com>
References: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
	<7C8F8758-DE9E-46D3-AB30-236EB20F8A4B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pavel Machek <pavel@ucw.cz>, hch@infradead.org,
	lczerner@redhat.com, "Theodore Ts'o" <tytso@mit.edu>,
	Tyler Hicks <tyhicks@canonical.com>,
	Serge Hallyn <serge.hallyn@canonical.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:51454 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaGWXCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2014 19:02:00 -0400
Received: by mail-ig0-f170.google.com with SMTP id h3so5904168igd.3
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2014 16:01:59 -0700 (PDT)
In-Reply-To: <7C8F8758-DE9E-46D3-AB30-236EB20F8A4B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Reposting in plain text; the previous cut-and-paste resulted in LKML-h=
ostile
message format.)

On Wed, Jul 23, 2014 at 3:39 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On Jul 23, 2014, at 3:23 PM, Michael Halcrow <mhalcrow@google.com> wr=
ote:
>> This patchset proposes a method for encrypting in EXT4 data read and
>> write paths. It's a proof-of-concept/prototype only right now.
>
> Maybe it is worthwhile to take a step back and explain what your over=
all
> goal is?  What is the benefit of implementing crypto at the filesyste=
m
> level over at the block device level?  Are you targeting per-user cry=
pto
> keys?  Fast secure deletion of files by having per-inode keys that ar=
e
> encrypted by the filesystem/user key and then clobbered at deletion t=
ime?
>
> What is the threat model?  Without knowing that, there isn't any poin=
t
> in designing or implementing anything.

My apologies for leaving those details sparse. I have a fairly large
design document that I need to prune for publication, but I can
copy-and-paste the adversarial models section here. The current
patchset targets Phase 1. The primary use case at the moment
is the Chromium OS user cache.

I don't want to get bogged down in the details around the later phases
at the moment though, because there is related work with IMA that
needs to be taken into consideration.

=3D=3D=3D
Adversarial Models

The EXT4 encryption effort will have multiple phases and development
with various features. The first version will focus exclusively on
attacks against file content (not metadata) confidentiality under a
single point-in-time permanent offline compromise of the block device
content. Later features will add resiliency in the face of an
adversary who is able to manipulate the offline block device content
prior to the authorized user later performing EXT4 file system I/O on
said content.

We are not currently planning on attempting any mitigations against
timing attacks. We recognize that these are important to address, but
we consider that to be primarily a Linux kernel Crypto API
issue. Addressing timing attacks against users of the Crypto API is
out of scope for this document.

Phase 1 Model

With the initial set of features, we will target the narrowly-scoped
threat of a single point-in-time permanent offline compromise of the
block device content, where loss of confidentiality of file metadata,
including the file sizes, names, and permissions, is tolerable.

An example scenario is the Chromium OS user cache, where the file
names can be tokenized at the application layer.

Phase 2 Model

We will additionally protect the confidentiality of file sizes, names,
permissions, etc. in the face of a single point-in-time permanent
offline compromise of the block device content. A mount-wide protector
will be shared among all users of the file system, and so one user on
a system will be able to manipulate the metadata of other users=E2=80=99
files.

This behavior is necessary for the Chromium OS user cache scenario,
where one user must be able to delete cache content for another user.

Phase 3 Model

We will add per-block authentication tags to the data pages to protect
file content integrity. At this point, the threat scope increases to
include occasional temporary offline compromise of the block device
content. "Occasional" means that an observer will be able to read
and/or manipulate the offline ciphertext and/or authentication tags on
the order of dozens of times in the lifetime of the file system. File
metadata will still be subject to undetected corruption, particularly
by other users on the system who gain access to the block device
content. However, some types of metadata manipulation, such as file
size or block mapping corruption, can be detected when validating the
integrity of the file contents.

Phase 4 Model

We will add in-place cryptographic context conversion to facilitate
transparent live encryption and key rotation. This will address the
threat of a key being compromised due over-exposure (e.g., amount of
data encrypted with the same key, age of key, amount of time the key
has been resident in memory under various run-time circumstances,
etc.).

Phase 5 Model

We will add TPM protectors to require boot sequence integrity to
release the encryption keys. This will address the threat of an
attacker replacing measurable components in the boot sequence up to
and including the kernel.

Phase 6 Model

We will add versioning support to mitigate rollback attacks. This will
address the threat of an attacker snapshotting a previous portion of
the block device content and restoring that portion at a later time.
=3D=3D=3D

>
> Hopefully you are already aware of the ext4 metadata checksum feature=
 that
> is in newer kernels?  That might be useful for storing your strong cr=
ypto
> integrity hashes for filesystem metadata.

I'm aware of that work and am evaluating it as a potential vehicle for
storing the
metadata.

> We've also previously discussed storing file-data checksums in some f=
orm.
> One of the leading candidates being either a per-block table of check=
sums
> that are statically mapped either for every block in the filesystem, =
or
> only to the "data" blocks of the filesystem (i.e. those that don't co=
ntain
> fixed metadata that already has its own checksums such as inode table=
s,
> bitmaps, and backup group descriptors/superblocks).  The other possib=
ility
> is storing checksums with each extent, with the option to make the ex=
tents
> as small or large as needed.  See thread starting at:
> http://www.spinics.net/lists/linux-ext4/msg42620.html
>
> Once we understand what the actual security goals and threat model ar=
e,
> then it will be easier to determine the best way to implement this.
>
> Cheers, Andreas
>
>> Outstanding issues:
>>
>> * While it seems to work well with complex tasks like a parallel
>>   kernel build, fsx is pretty good at reliably breaking it in its
>>   current form. I think it's trying to decrypt a page of all zeros
>>   when doing a mmap'd write after an falloc. I want to get feedback
>>   on the overall approach before I spend too much time bug-hunting.
>>
>> * It has not undergone a security audit/review. It isn't IND-CCA2
>>   secure, and that's the goal. We need a way to store (at least)
>>   page-granular metadata.
>>
>> * Only the file data is encrypted. I'd like to look into also
>>   encrypting the file system metadata with a mount-wide key. That's
>>   for another phase of development.
>>
>> * The key management isn't fleshed out. I've hacked in some eCryptfs
>>   stuff because it was the fastest way for me to stand up the
>>   prototype with real crypto keys. Use ecryptfs-add-passphrase to ad=
d
>>   a key to the keyring, and then pass the hex sig as the
>>   encrypt_key_sig mount option:
>>
>> # apt-get install ecryptfs-utils
>> # echo -n "hunter2" | ecryptfs-add-passphrase
>> Passphrase:
>> Inserted auth tok with sig [4cb927ea0c564410] into the user session =
keyring
>> # mount -o encrypt_key_sig=3D4cb927ea0c564410 /dev/sdb1 /mnt/ext4cry=
pt
>>
>> * The EXT4 block size must be the same as the page size. I'm not yet
>>   sure whether I will want to try to support block-granular
>>   encryption or page-granular encryption. There are implications wit=
h
>>   respect to how much the integrity data occupies in relation to the
>>   encrypted data.
>>
>> Mimi, maybe an approach like this one will work out for IMA. We've
>> just got to figure out where to store the block- or page-granular
>> integrity data.
>>
>> I've broken up the patches so that not only can each one build after
>> application, but discrete steps of functionality can be tested one
>> patch at a time.
>>
>> A couple of other thoughts:
>>
>> * Maybe the write submit path can complete on the encryption
>>   callback. Not sure what that might buy us.
>>
>> * Maybe a key with a specific descriptor in each user's keyring
>>   (e.g. "EXT4_DEFAULT_KEY") can be used when creating new files so
>>   that each user can use his own key in a common EXT4 mount. Or mayb=
e
>>   we can specify an encryption context in the parent directory xattr=
=2E
>>
>> Michael Halcrow (5):
>>  ext4: Adds callback support for bio read completion
>>  ext4: Adds EXT4 encryption facilities
>>  ext4: Implements the EXT4 encryption write path
>>  ext4: Adds EXT4 encryption read callback support
>>  ext4: Implements real encryption in the EXT4 write and read paths
>>
>> fs/buffer.c                 |  46 +++-
>> fs/ext4/Makefile            |   9 +-
>> fs/ext4/crypto.c            | 629 ++++++++++++++++++++++++++++++++++=
++++++++++
>> fs/ext4/ext4.h              |  50 ++++
>> fs/ext4/file.c              |   9 +-
>> fs/ext4/inode.c             | 196 +++++++++++++-
>> fs/ext4/namei.c             |   3 +
>> fs/ext4/page-io.c           | 182 ++++++++++---
>> fs/ext4/super.c             |  34 ++-
>> fs/ext4/xattr.h             |   1 +
>> include/linux/bio.h         |   3 +
>> include/linux/blk_types.h   |   4 +
>> include/linux/buffer_head.h |   8 +
>> 13 files changed, 1118 insertions(+), 56 deletions(-)
>> create mode 100644 fs/ext4/crypto.c
>>
>> --
>> 2.0.0.526.g5318336
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsde=
vel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Cheers, Andreas
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
