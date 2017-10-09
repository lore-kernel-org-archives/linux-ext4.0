From: Nicolas Dechesne <nicolas.dechesne@linaro.org>
Subject: Re: e2fsprogs: building ext2simg
Date: Mon, 9 Oct 2017 10:24:46 +0200
Message-ID: <CAP71WjwVdqmLEq1NGWK36JkEd-i05YcAu4jeY6GFjsk6TS=Mtg@mail.gmail.com>
References: <CAP71WjzSUxbK1mpv_bTuZd6W4xV2zNEEQN0GtmEp7iMTyhi9zA@mail.gmail.com>
 <20171008212752.ljga227riyq7exzb@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:50355 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdJIIZI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Oct 2017 04:25:08 -0400
Received: by mail-qt0-f181.google.com with SMTP id f15so41658055qtf.7
        for <linux-ext4@vger.kernel.org>; Mon, 09 Oct 2017 01:25:07 -0700 (PDT)
In-Reply-To: <20171008212752.ljga227riyq7exzb@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi Theo,

thanks for the very detailed answer!

On Sun, Oct 8, 2017 at 11:27 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Oct 08, 2017 at 10:04:21PM +0200, Nicolas Dechesne wrote:
>> hi,
>>
>> ext2simg.c file was moved from android (system/extras) into e2fsprogs.
>> however it seems that it cannot be compiled outside of android (it
>> uses sparse/sparse.h). some distro used to build/package this utility
>> (e.g. debian has it in android-tools-fsutils).
>>
>> what was the main reason why it was moved into e2fsprogs in the first
>> place, given that it cannot be compiled (easily) outside of AOSP?
>
> I've been pushing a long-term effort to try to rid the world from
> make_ext4fs, which only exists at all because there was a time when
> there were people who greatly feared the GPLv2.  So the idea was that
> AOSP would never use any GPLv2 code, and AOSP would use make_ext4fs,
> and Android devices would *never* need to do silly things like run
> e2fsck.  (This was a long time ago, but we've been still paying for
> that design decision, with interest.)
>
> Unfortunately, make_ext4fs was a clean room implementation of mke2fs,
> which means it had gotten a number of things wrong.  Worse, it was
> originally meant to work (only) as part of the build process using
> sparse files or later, libsparse, and so it assumes that an unwritten
> block is all zeros.
>
> This even mostly worked on flash devices, assuming that the device
> actually bothered to honor the discard/trim "hint" --- but it was a
> complete nightmare for devices using dm-crypt, since the trim/discard
> would result in the underlying blocks to be zero, but then when
> dm-crypt read back the blocks that were supposed to be zeroed, the
> decryption would cause the block to have some random data.  Hilarity
> would then ensue --- but only in very random, edge cases.
>
> I've lost track of the number of times I've been asked to assist when
> make_ext4fs has screwed up in some wonderous fashion, and there has
> been some internal bug, usually but not always involving a
> user-initiated factory reset, that had stumped the good folks on the
> Android team, and then I would get asked to assist.
>
> Unfortunately, make_ext4fs and its associated tools have accumulated a
> number of extra functionality (populating the empty file system,
> adding SELinux attributes, etc.), so trying to make replacements that
> don't depend on a clean-room implementation of e2fsprogs and its
> library has been a long, and not completely finished, journey.  Still,
> thanks to a summer intern last year, and some assistance from folks in
> the Android team, we're almost there.
>
> Anyway, the version of ext2simg in e2fsprogs uses the ext2fs library,
> and since the cutover from make_ext4fs to mke2fs has been done on a
> device by device basis (to minimize the risks of breakage), it was
> simpler to make the e2fsprogs-dependent version of ext2simg live in
> the e2fsprogs git tree.
>
> As far as why it's in the upstream e2fsprogs tree, I've been making an
> effort to keep the upstream and AOSP versions of e2fsprogs more
> closely aligned, so it's easier for AOSP to update to a newer version
> of e2fsprogs.
>
> You can now upgrade to a newer version of e2fsprogs by doing a "git
> merge", which used to not work at all.  Now, it might result in some
> merge conflicts, but at least there is a common git ancestor so the
> merge has a chance of working.

I agree that getting ext2simg closer to upstream and ext2fs was the
right thing to do, i have faced issues with make_ext4fs as well, so I
am aware of what you are discussing here!

>
> As far as it being hard to compile libsparse outside of AOSP, it would
> be great if someone were to package libsparse and libsparse-dev for
> Debian.  If they do so, I'll be glad (as debian maintainer) to package
> up the e2fsprogs variants of these tools.  We'll probably need to give
> them a different package name so that both versions of the packages
> can exist at least in the package namespace, if not installed at the
> same time on a Debian system.  But we can deal with that problem when
> we get there.

libsparse is already available in Debian, in android-libsparse-dev
package, but it's being packaged from the full system/core, not
standalone.

In fact, building the 'new' ext2simg is exactly what I needed to do,
and the reason why i started to investigate what happened to
ext2simg.. the real reason why i've been looking into that , is that I
have noticed that my file system gets corrupted when doing ext2simg ->
simg2img. we are building ext4 file system for small dev boards that
are meant to be flashed with fastboot, so our workflow is:

mkfs.ext4 xxx
-> fill in the image
ext2simg

What i've noticed is that if we upgrade our servers running Debian
Jessie , this no longer works and after doing simg2img (or flashing
with fasboot) the files in the file system are corrupted (md5sum
differ).

The problems appears as soon as I upgrade from e2fsprogs 1.42.12-2+b1
(the version in Jessie) to either the version in Stretch or the
version in jessie-backport. So it looks like e2fsprogrs 1.43, breaks
something with existing ext2simg (I am using ext2simg from
android-tools-fsutils, so the 'old' one).

if i use img2simg, then of course, there is no corruption.

>
>> Also, the commit that brought this file has the following reference:
>>
>>     From AOSP commit: c1b7d19958dc3dbe53810811ea3dcc4f04f85c73
>>
>> However I don't think this commit in AOSP.
>
> Hmm... I don't have easy access to AOSP at the moment, since I'm at
> home and it's not on my upstream development laptop, but is it
> possible that the contents of the git commit exists, but with a
> different git commit ID?  My understanding is that changes to
> external/e2fsprogs, once code reviewed in Gerrit, do get pushed out to
> the AOSP master branch right away.  Android source trees have a
> massively complex merging scheme, and the most likely explanation is
> that I used the git commit ID belonging to some merge into a tree that
> isn't published in AOSP.  Either that, or the commit ID got somehow
> corrupted while it was in my editor doing the cherry-pick into the
> upstream tree.

argh. too bad, we lost the back link..

>
> Cheers,
>
>                                         - Ted
>
> P.S.  One of the other really nice things you can do as a result of a
> lot of this effort is you can now build tools such as debugfs for
> Android, built against bionic.  So it becomes a lot easier to build a
> userdebug android image that includes debugfs, which is helpful if you
> need to try to debug some interesting new failure.
>
> And using mke2fs instead of make_ext4fs means that if we do add some
> new file system feature into ext4/e2fsprogs which Android wants to
> depend upon, it will be a lot easier to keep things in sync with the
> external upstream world.

[1] https://packages.debian.org/sid/android-libsparse
