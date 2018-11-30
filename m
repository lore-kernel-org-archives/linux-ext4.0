Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60658 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbeLAH45 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 02:56:57 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 01/12] libe2p: Helpers for configuring the encoding superblock fields
References: <20181126221949.12172-1-krisman@collabora.com>
        <20181126221949.12172-2-krisman@collabora.com>
        <20181130154243.GR31885@thunk.org>
Date: Fri, 30 Nov 2018 15:46:20 -0500
In-Reply-To: <20181130154243.GR31885@thunk.org> (Theodore Y. Ts'o's message of
        "Fri, 30 Nov 2018 10:42:43 -0500")
Message-ID: <878t1a1eg3.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> On Mon, Nov 26, 2018 at 05:19:38PM -0500, Gabriel Krisman Bertazi wrote:
>> +	/* 0x1 */ {"utf8-10.0", (EXT4_UTF8_NORMALIZATION_TYPE_NFKD |
>> +				 EXT4_UTF8_CASEFOLD_TYPE_NFKDCF)},
>
> We're using 10.0 here even though the later in the patch we're
> installing Unicode 11.0.  What if we just call this utf8-10+?  Unicode
> releases new versions every six months these days, and so long as the
> case fold rules don't change for any existing characters, but are only
> added for new characters added to the new version of Unicode, it would
> definitely be OK for strict mode.
>
> Even in relaxed mode, if someone decided to use, say, Klingon
> characters not recognized by the Unicode consortium in their system,
> and later on the Unicode consortium reassigns those code points to
> some obscure ancient script, it would be unfortunate, how much would
> it be *our* problem?  The worst that could happen is that if case
> folding were enabled, two file names that were previously unique would
> be considered identical by the new case folding rules after the
> rebooting into the new kernel.  If hashed directories were used, one
> or both of the filenames might not be accessible, but it wouldn't lead
> to an actual file system level inconsistency.  And data would only be
> lost if the wrong file were to get accidentally deleted in the
> confusion.

If this is not our problem, it does get much easier.  But we might be
able to assist the user a bit more, if we store the version in the
superblock.

We only allow the user to specify utf8 without requiring a version in
mkfs, just like you said, but we still write the unicode version in the
superblock.  The kernel will always mount using the newest unicode, but
recommend the user to run fsck if there is a version mismatch.  fsck can
then check the filesystem using first the newest version, and if an
invalid is found, it tries to use the exact superblock version.  If the
second attempt doesn't fail, we can rehash the entry, because no real
inconsistencies actually exist. If the rehash triggers a collision, we
could ask the user interactively what to do, if we can be interactive in
fsck (we can't, right?).  Otherwise, if we can't solve the collisions,
we set a flag in the superblock to force the exact version when mounting
the next time.  The user loses normalization of new scripts, but we warn
them about it, and the existing data is preserved and accessible.
Finally, if no collision is detected, or if we can solve all of then, we
write the new hashes and silently update the unicode version flag in the
superblock in fsck.

The interface becomes simpler for the common user, we basically hide
unicode versioning from someone that is not playing with ancient
scripts, and they still benefit from the new version by just rebooting
to an updated kernel.  But we still give the user that actually cares
about ancient scripts a way to fix her situation.

> I'm curious how Windows handles this problem.  Windows and Apple are
> happy to include the latest set of emoji's as they become available
> --- after all, that's a key competitive advantage for some markets :-)
> --- so I'm guessing they must not be terribly strict about Unicode
> versioning, either.  So maybe the right thing to do is to just call it
> "utf8" and be done with it.  :-)

I just did some tests on a macbook.  The machine was on xnu-4570.71.1~1,
which is pre-unicode 11 and creating a file with a unicode 11+ sequence
triggers an "illegal byte sequence" error.  After updating the system
(to xnu-4903.221.2), i can create files using new emoticons. So, from what
i can tell, apple is using a more strict mode that reject invalid
sequences.

Windows seems more permissive, I can create a unicode 11 file on a
system I am sure doesn't have unicode 11 support, since it is much older
than that version, and I can check the file name on disk is the one i
asked for.

-- 
Gabriel Krisman Bertazi
