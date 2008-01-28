From: Matthias Koenig <mkoenig@suse.de>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Mon, 28 Jan 2008 16:26:53 +0100
Message-ID: <n7x1w82nf7m.fsf@sor.suse.de>
References: <20080124211728.GA24900@webber.adilger.int>
	<n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, hvogel@suse.de,
	Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:37971 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbYA1P0z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 10:26:55 -0500
In-Reply-To: <20080127050543.GC24842@mit.edu> (Theodore Tso's message of "Sun\,
	27 Jan 2008 00\:05\:43 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> Wow.  You have a lot of patches in the SLES 10 e2fsprogs.  I'm not
> sure why of them are there, though.  For example:
>
> Patch0:         elf.diff
>
> I'm not sure what this one is for.
>
> Patch1:		e2fsprogs-1.35-libdir.diff
>
> This one does two different things.  One is include AC_HEADER_TIME in
> configure.in, and the other is to use $lib instead of "lib" when
> defining root_libdir.  This seems to force root_libdir to /, which
> makes no sense to me.

We want to have the shared libs in /lib{,64}, but the devel so links
have to remain in /usr/lib{,64}. 
But looking closer at this, it seems that these patches are not needed,
since the result can be obtained by defining ELF_INSTALL_DIR.
I will drop these.

> Patch4:         e2fsprogs-blkid.diff
>
> This patch causes fsck to check the BLKID_FILE environment variable
> and passes it to the blkid library.  But the blkid library *already*
> checks the BLKID_FILE environtment variable already.  So I'm not sure
> why this is necessary at all.

Ok, the patch is obsolete indeed.

> Patch6:         e2fsprogs-mdraid.patch
>
> This apparently adds a new environment variable,
> BLKID_SKIP_CHECK_MDRAID, which forces blkid to not detect mdraid
> devices.  I'm not sure why.

Workaround for people having stale RAID signature on their disk:
https://bugzilla.novell.com/show_bug.cgi?id=100530

> Patch10:        close.patch
>
> I don't understand what this patch is trying to do.

This patch is obsolete, as the issue is fixed by
git commit 0d961040fe9ad927254b5a0e1a4de7bedadd8579

The original patch posted in Novell bugzilla #132708
contained this additional hunk, which is likely obsolete:
@@ -217,6 +217,7 @@
 	
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
+	super_shadow = fs->super;
 	fs_state = fs->super->s_state;
 
 	fs->super->s_wtime = time(NULL);

> Patch12:        e2fsprogs-mkinstalldirs.patch
>
> Why?

Is needed since we recreate the auto* files.
But I agree that this patch should better set
MKINSTALLDIRS = @MKDIR_P@
not to literal "mkdir -p". The @MKINSTALLDIRS@ seems to be
obsolete in newer gettext (which seems to pull this in).

> Patch22:        e2fsprogs-1.40.4-uuidd_pid_path.patch
>
> The problem with this patch is that /var/run is cleared via rm -rf, so
> it is highly problamtic to put the scratch directory for uuidd in
> /var/run.

Are you really sure? My interpretation of FHS is, that files under
/var/run/ have to be cleared or truncated, but the subdirectories do not
get deleted.

> Patch34:        libcom_err-compile_et_permissions.patch
>
> Why?

This is just a workaround and is not intended to stay there forever,
it is also not intended for upstream inclusion.
I have been asked to add this to avoid build problems of some other
package (I think it was kerberos). I will have to check if this is
still needed.

Thanks,
Matthias
