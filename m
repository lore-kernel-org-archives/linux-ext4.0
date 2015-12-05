From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] tune2fs: confirm slow/dangerous operations
Date: Fri, 4 Dec 2015 17:12:02 -0800
Message-ID: <20151205011202.GL10580@birch.djwong.org>
References: <20151203204024.GI10580@birch.djwong.org>
 <ADF3DE2C-3BAF-4678-8B9B-7220F3333FE1@dilger.ca>
 <20151204230745.GJ10580@birch.djwong.org>
 <C3F58672-86A5-438F-BE3D-DCAFE0B80C33@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27513 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbbLEBMI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 20:12:08 -0500
Content-Disposition: inline
In-Reply-To: <C3F58672-86A5-438F-BE3D-DCAFE0B80C33@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 04, 2015 at 04:54:01PM -0700, Andreas Dilger wrote:
> On Dec 4, 2015, at 4:07 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > On Fri, Dec 04, 2015 at 03:12:53PM -0700, Andreas Dilger wrote:
> >> On Dec 3, 2015, at 1:40 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >>> 
> >>> Give admins a short amount of time to confirm that they want to
> >>> proceed with a dangerous operation.  Refuse to perform the op
> >>> unless the filesystem is freshly checked.
> >>> 
> >>> Cc: Andreas Dilger <adilger@dilger.ca>
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>> ---
> >>> misc/tune2fs.c           |   41 ++++++++++----
> >>> tests/t_dangerous/expect |   97 +++++++++++++++++++++++++++++++++
> >>> tests/t_dangerous/name   |    1
> >>> tests/t_dangerous/script |  134 ++++++++++++++++++++++++++++++++++++++++++++++
> >>> 4 files changed, 260 insertions(+), 13 deletions(-)
> >>> create mode 100644 tests/t_dangerous/expect
> >>> create mode 100644 tests/t_dangerous/name
> >>> create mode 100644 tests/t_dangerous/script
> >>> 
> >>> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> >>> index af7d73c..aaa1597 100644
> >>> --- a/misc/tune2fs.c
> >>> +++ b/misc/tune2fs.c
> >>> @@ -405,14 +405,25 @@ static int update_mntopts(ext2_filsys fs, char *mntopts)
> >>> 	return 0;
> >>> }
> >>> 
> >>> -static int check_fsck_needed(ext2_filsys fs)
> >>> +static void check_fsck_needed(ext2_filsys fs, const char *prompt)
> >>> {
> >>> -	if (fs->super->s_state & EXT2_VALID_FS)
> >>> -		return 0;
> >>> -	printf("\n%s\n", _(please_fsck));
> >>> -	if (mount_flags & EXT2_MF_READONLY)
> >>> -		printf("%s", _("(and reboot afterwards!)\n"));
> >>> -	return 1;
> >>> +	/* Refuse to modify anything but a freshly checked valid filesystem. */
> >>> +	if (!(fs->super->s_state & EXT2_VALID_FS) ||
> >>> +	    (fs->super->s_state & EXT2_ERROR_FS) ||
> >>> +	    (fs->super->s_lastcheck < fs->super->s_mtime)) {
> >>> +		printf("\n%s\n", _(please_fsck));
> >>> +		if (mount_flags & EXT2_MF_READONLY)
> >>> +			printf("%s", _("(and reboot afterwards!)\n"));
> >>> +		exit(1);
> >>> +	}
> >> 
> >> Should this explicitly check for NEEDS_RECOVERY, or force journal replay
> >> directly?  It would be a sad thing if the filesystem was modified and then
> >> journal replay clobbered it.
> > 
> > I was under the impression that the patch "tune2fs: warn if the filesystem
> > journal is dirty" was sufficient to discourage journal-clobbering?
> > 
> > AFAICT, that patch runs for any invocation of tune2fs, whereas
> > check_fsck_needed only applies to "dangerous" operations, i.e. the ones that
> > want to rewrite big chunks of FS.
> 
> That check is fine as a warning for "simple" changes (e.g. setting a flag in
> the superblock), since if it gets clobbered when there _may_ be a superblock
> in the journal it isn't any worse than if it was never set at all.
> 
> For "dangerous" options like these, if the filesystem is modified and then
> the journal is replayed (e.g resize inodes, replay journal with old inode
> table blocks on top of the modified inodes) the results would be disastrous.
> 
> So for dangerous options it makes sense to either refuse to change the filesystem
> if the journal is dirty, or replay the journal before changing the filesystem
> if the proceed question is accepted.

I think it makes most sense always to replay the journal if it needs recovery.
No need to tell the admin they have to do something if we can do it for them.

--D

> 
> It wouldn't be terrible to have a proceed question if the journal is dirty
> to see if they want to replay the journal before any field is modified, and
> just revert the warning patch.
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


