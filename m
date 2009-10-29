From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 29 Oct 2009 22:20:18 GMT
Message-ID: <200910292220.n9TMKIa4019008@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38136 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZJ2WUN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 18:20:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TMKIbn019009
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 22:20:18 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #149 from Theodore Tso <tytso@mit.edu>  2009-10-29 22:20:16 ---
Avery,

>In this bug i do not trust distribution to run fsck, so i do it manually. I
>start in to initrd, so root is not mounted! Then i mount it manually to be sure
>it is readonly. Normally i mounted on this stage with option "-o ro". The
>result of thees was - we newer so "jurnal corruption", because the kernel
>silently "repaired" it.

I think there's some confusion here.  If there is journal corruption, you would
see a complaint in the dmesg logs after the root filesystem is mounted.  One of
the changes which did happen as part of 2.6.32-rc1 is that journal checksums
are enabled by default.  This is a *good* thing, since if there are journal
corruptions, we find out about them.   Note that in this case, journal
corruption usually means an I/O error has occurred, causing the checksum to be
incorrect.

Now, one of the problem is that we don't necessarily have a good recovery path
if the journal checksums don't check out, and the journal replay is aborted.  
In some cases, finishing the journal replay might actually cause you to be
better off, since it might be that the corrupted block occurs later in the
journal in a correct fashion, and a full journal replay might cause you to be
lucky.  In contrast, aborting the journal might end up with more corruptions
for fsck to fix.

>Now i use "-o ro,noload" to mount root and run fsck (not to reproduce crush).
>And now i can see, journal is not corrupted after normal crush. If yournall is
>corrupt all fs is corrupt too.

OK, so "mount -o ro,noload" is not safe, and in fact the file system can be
inconsistent if you don't replay the journal.  That's because after the
transaction is committed, the filesystem starts staging writes to their final
location to disk.  If we crash before this is complete, the file system will be
inconsistent, and we have to replay the journal in order to make the file
system be consistent.   This is why we force a journal replay by default, even
when mounting the file system read-only.  It's the only way to make sure the
file system is consistent enough that you can even *run* fsck.  (Distributions
that want to be extra paranoid should store fsck and all of its needed files in
the initrd, and then check the root filesystem before mounting it ro, but no
distro does this as far as I know.)   (Also, in theory, we could implement a
read-only mode where we don't replay the journal, but instead read the journal,
figure out all of the blocks that would be replayed, and then intercept all
reads to the file system such that if the block exists in the journal, we use
the most recent version of the block in the journal instead of the physical
location on disk.  This is far more complicated than anyone has had time/energy
to write, so for now we take the cop-out route of replaying the journal even
when the filesystem is mounted read-only.

If you do mount -o ro,noload, you can use fsck to clean the filesystem, but per
my previous comment in this bug report, you *must* reboot in this case
afterwards, since fsck modifies the mounted root filesystem to replay the
journal, and there may be cached copies of the filesystem that are modified in
the course of the replay of the journal by fsck.  (n.b., it's essentially the
same code that is used to replay the journal, regardless of whether it is in
the kernel or in e2fsck; the journal recovery.c code is kept in sync between
the kernel and e2fsprogs sources.)  

>Now is the question: do we use journal to recover fs? if we use broken journal
>how this recovery will look like? Do we get this "multiply claimed blocks"
>because we get wrong information from journal and this is the reason, why some
>times files which was written long time before are corrupt too?

Again, I think there is some confusion here.   If the journal is "broken" (aka
corrupted) you will see error messages from the kernel and e2fsck when it
verifies the per-commit checksum and notices a checksum error.  It won't know
what block or blocks in the journal were corrupted, but it will know that one
of the blocks in a particular commit must have been incorrectly written, since
the commit checksum doesn't match up.    In that case, it can be the cause of
file system corruption --- but it's hardly the only way that file system
corruption can occur.  There are many other ways it could have happened as
well.

It seems unlikely to me that the "multiply claimed blocks" could be caused
directly by wrong information in the journal.  As I said earlier, what is most
likely is the block allocation bitmaps are getting corrupted, and then the file
system was mounted read/write and new files written to it.  It's possible the
bitmaps could have been corrupted by a journal replay, but that's only one of
many possible ways that bitmap blocks could have gotten corrupted, and if the
journal had been corrupted, there should have been error messages about journal
checksums not being valid.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
