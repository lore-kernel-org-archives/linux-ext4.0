From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: backporting ext4 to 2.6.27
Date: Mon, 9 May 2011 18:52:48 -0400
Message-ID: <BANLkTinYoendEHf=fOtnoS=QyrVXJZZnqg@mail.gmail.com>
References: <86980.98056.qm@web95210.mail.in2.yahoo.com> <20110509160548.GC19811@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: puru sothaman <r.puru@yahoo.co.in>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58753 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab1EIWxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 18:53:49 -0400
Received: by bwz15 with SMTP id 15so4373103bwz.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 15:53:47 -0700 (PDT)
In-Reply-To: <20110509160548.GC19811@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 9, 2011 at 12:05 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, May 09, 2011 at 08:16:09PM +0530, puru sothaman wrote:
>> Hi,
>>
>> =A0 =A0I am using 2.6.27.18 kernel.Currently the ext4 support in ker=
nel
>>is experimental version.I need a stable version ext4 patches for the
>>above kernel.Can anyone help me in backporting the stable ext4
>>patches for 2.6.27 kernel.
>
> Backporting patches to an ancient kernel like 2.6.27 is one of those
> painful things that get done by people who are paid to do so --- it's
> hard to find volunteers willing to do such a grungy task....
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 - Ted

Puru,

As far as I know, 2.6.27 is not supported for any of the current
security patches.

openSUSE as an example 100% stopped back-porting security patches to
it in Jan 2011 I believe.  I don't know how many ext4 patches they or
the community backported prior to that.  As you said, it was
experimental ...

You can find the latest openSUSE 2.6.27 kernel source here:
https://build.opensuse.org/package/files?package=3Dkernel-source&projec=
t=3DDISCONTINUED%3AopenSUSE%3A11.1%3AUpdate

If you look at series.conf in particular, you can see they advanced as
far as the 2.6.27.56 stable kernel.

Then they were reverting a few things from the official tree:

    patches.kernel.org/revert-ext4-changes-in-2.6.27.48.patch
    patches.kernel.org/revert-ext4-changes-in-2.6.27.47.patch
    patches.kernel.org/revert-vfs-remove-the-range_cont-writeback-mode.=
-in-2.6.27.47.patch
    patches.kernel.org/revert-ext4-changes-in-2.6.27.19-and-2.6.27.20-a=
nd-2.6.27.25.patch


Then in addition they were applying:

# ext2/ext3
    ########################################################
    patches.suse/ext3-barrier-default
    patches.suse/ext2-fsync-err
    patches.fixes/ext3-mark-super-uptodate
    patches.fixes/ext3_false_EIO_fix.diff
    patches.fixes/ext2_mtime_update_on_rename.diff

    ########################################################
    # ext4
    ########################################################
    patches.fixes/ext4-fixes-2.6.28-rc8.patch
    patches.fixes/ext4-mballoc-preallocate.patch
    patches.fixes/ext4-use-a-fake-block-number-for-delayed-new-buffer_h=
ead
    patches.fixes/ext4-fix-sub-block-zeroing-for-preallocated-writes
    patches.fixes/ext4-clear-unwritten-flag-after-extent-initialization
    patches.fixes/ext4-avoid-corrupting-the-uninitialized-bit-in-the-ex=
tent-during-truncate
    patches.fixes/ext4-avoid-divide-by-zero-when-trying-to-mount-a-corr=
upted-file-system

    patches.fixes/ext4-fix-i_flags-access-in-ext4_da_writepages_trans_b=
locks
    patches.fixes/ext4-fix-potential-buffer-head-leak-when-add_dirent_t=
o_buf-returns-enospc
    patches.fixes/ext4-fix-uninit-block-bitmap-initialization-when-s_me=
ta_first_bg-is-non-zero
    patches.fixes/ext4-journal-all-modifications-in-ext4_xattr_set_hand=
le
    patches.fixes/ext4-make-sure-directory-and-symlink-blocks-are-revok=
ed
    patches.fixes/ext4-plug-a-buffer_head-leak-in-an-error-path-of-ext4=
_iget
    patches.fixes/ext4-return-the-ptr_err-of-the-correct-pointer-in-set=
up_new_group_blocks
    patches.fixes/jbd2-fix-race-between-write_metadata_buffer-and-get_w=
rite_access
    patches.fixes/jbd2-add-enomem-checking-in-and-for-jbd2_journal_writ=
e_metadata_buffer
    patches.fixes/percpu_counter-fbc_batch-should-be-a-variable-ext4
    patches.fixes/ext4-consolidate-in_range-definitions

You should find all of those patches in the link I posted.

 (See files:
                               patches.kernel.org.tar.bz2,
                               patches.suse.tar.bz2,
                               patches.fixes.tar.bz2
)

In fact, all of the patches to go from 2.6.27 to 2.6.27.56 should be
in the patches.kernel.org.tar.bz2 file.

I don't know how 'stable' that makes the 2.6.27 kernels ext4
implementation, but you can see ext4 got a lot of patches even though
it was officially experimental.

One thing it definitely doesn't do is add any backports that have come
out since the first of the year.  And I doubt any of the other distros
are doing that either.

fyi:

The stable patches are back-ported to 2.6.32 I believe.  That kernel
has also been designated by SUSE and Red Hat as a long term support
kernel, so it gets lots of security patches.

Can't you upgrade to it at least.

If so, you can likely stick with it for a couple more years and get a
full set of security patches as part of the pay-off.

Good Luck
Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
