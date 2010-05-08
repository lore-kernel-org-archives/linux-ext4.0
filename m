From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Sat, 8 May 2010 07:48:49 -0400
Message-ID: <8D8944AA-9368-4E4F-B91D-5CEEE6E2EE2A@mit.edu>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com> <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com> <20100504224226.GE6344@thunk.org> <p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com> <87vdaz21b0.fsf@basil.nowhere.org> <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com> <4BE4855E.40808@redhat.com> <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ric Wheeler <rwheeler@redhat.com>, Andi Kleen <andi@halobates.de>,
	linux-ext4@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:44471 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803Ab0EHLsz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 May 2010 07:48:55 -0400
In-Reply-To: <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On May 8, 2010, at 1:43 AM, Amir G. wrote:

> 1. No features are added to Ext3, so there is no concern for the
> stability of Ext3.
> The feature is added as a new f/s, with the slight overhead of
> duplicate code in the
> kernel tree and an extra loadable module in the system.

This is where it's important to understand exactly what is meant by a ***file system***.   Are you referring to the format, or the implementation?   The way I've always treated it, and it's the way I believe most of the ext234 developers have treated it is, that what users call ext2, ext3, and ext4 are different _implementations_ of the same _file_ _system_ [format].    That is to say, ext4 simply happens to be a fuller, more complete implementation  of the same file system as ext2 and ext3.   Ext2 doesn't support certain features such as journaling and directory indexing; ext3 doesn't support some advanced features such as delayed allocation and extents, and requires that the journal always be present.   Ext4 is a superset of ext2 plus ext3 plus delayed allocation, extents, a multi-block 
 allocator, and a few other new features.   But they are all the same file system.

Nor are they the only implementations of that file system.  The BSD file systems have a compatible (although feature-restricted) implementation, which was independently implemented.  So does the GNU HURD.   And there are others.  And note that all of these folks all use the same userspace utilities, e2fsprogs, for all of these various implementations: BSD, GNU HURD, and the Linux implementations of ext2, ext3, and ext4 all use the same set of tools: mke2fs, e2fsck, tune2fs, debugfs, and so on.

The same this is true for NTFS.   There are features in NTFS that you will find in Windows Vista that don't exist in Windows NT or Windows Vista.  But everybody treats them as the same file system, even though they have more advanced features in newer versions of the operating system.

The "ext" in ext2 stands for "extended", as in the "the second extended file system" for Linux.   It perhaps would be better if we had used the term "extensible", since that's the main thing about ext2/3/4 that has given it so much staying power.  We've been able to add, in very carefully backwards and forwards compatible way, new features to the file system format.  This is why I object to why Next3 uses some fields that overlaps with ext4.   It means that e2fsprogs, which supports _one_ and _only_ _one_ file system format, will now need to support two file system formats.  And that's not something I want to do.

Put another away, it should be possible to add your "Next3" snapshots to ext4.   Even if today, no one has the time and energy to do the work, it is something that should be _theoretically_ possible.   In another e-mail message, you've made the claim: "Unfortunately, merging Next3 snapshots feature into Ext4 is not an easy task,
because extent mapped files break the design concepts of Next3 snapshots."     But aside from stealing fields already assigned to various features supported by ext4, this isn't true!  I don't see anything that fundamentally incompatible with Next3 and extent-mapped files.    (Unless you mean that the snapshot file might not be as efficiently stored using extent-mapped files, but [a] it's not clear the lack of efficiency will matter, since most files are contiguously stored, and there can be over 380 extents in a extent tree leaf block, and [b] we could always use an indirect block mapped file for the snapshot file --- ext4 is fully backwards compatible with ext2, so you can use an old-style direct/indirect block mapped file for the snapshot if you really wanted.)

-- Ted

