From: Andreas Dilger <adilger-KloliPT79xf2eFz/2MeuCQ@public.gmane.org>
Subject: Re: [PATCH 00/19 v5] Fix filesystem freezing deadlocks
Date: Mon, 16 Apr 2012 22:10:50 -0700
Message-ID: <141752A3-EDF1-4ABC-919D-4170B0455948@whamcloud.com>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
	<C9A0E2F0-ED57-40D6-9F75-5D72D45D21F0@dilger.ca>
	<20120417004329.GE6734@dastard>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org,
	KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>,
	OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>,
	linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	Mark Fasheh <mfasheh-IBi9RG/b67k@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	Ben Myers <bpm-sJ/iWh9BUns@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>,
	dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Alex Elder <elder-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-btrfs-u79uwXL29Tb/PtFMR13I2A@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20120417004329.GE6734@dastard>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2012-04-16, at 5:43 PM, Dave Chinner wrote:
> On Mon, Apr 16, 2012 at 03:02:50PM -0700, Andreas Dilger wrote:
>> On 2012-04-16, at 9:13 AM, Jan Kara wrote:
>>> Another potential contention point might be patch 19. In that patch
>>> we make freeze_super() refuse to freeze the filesystem when there
>>> are open but unlinked files which may be impractical in some cases.
>>> The main reason for this is the problem with handling of file deletion from fput() called with mmap_sem held (e.g. from munmap(2)),
>>> and then there's the fact that we cannot really force such filesystem
>>> into a consistent state... But if people think that freezing with
>>> open but unlinked files should happen, then I have some possible
>>> solutions in mind (maybe as a separate patchset since this is
>>> large enough).
>> 
>> Looking at a desktop system, I think it is very typical that there
>> are open-unlinked files present, so I don't know if this is really
>> an acceptable solution.  It isn't clear from your comments whether
>> this is a blanket refusal for all open-unlinked files, or only in
>> some particular cases...
> 
> Unlinked-but-open files are the reason that XFS dirties the log
> after the freeze process is complete. This ensures that if the
> system crashes while the filesystem is frozen then log recovery
> during the next mount will process the unlinked (orphaned) inodes
> and free the correctly. i.e. you can still freeze a filesystem with
> inodes in this state successfully and have everythign behave as
> you'd expect.
> 
> I'm not sure how other filesystems handle this problem, but perhaps
> pushing this check down into filesystem specific code or adding a
> superblock feature flag might be a way to allow filesystems to
> handle this case in the way they think is best...

The ext3/4 code has long been able to handle open-unlinked files
properly after a crash (they are put into a singly-linked list from
the superblock on disk that is processed after journal recovery).

The issue here is that blocking freeze from succeeding with open-
unlinked files is an unreasonable assumption of this patch, and
I don't think it is acceptable to land this patchset (which IMHO
would prevent nearly every Gnome system from freezing unless these
apps have changed their behaviour in more recent releases).

Like you suggest, filesystems that handle this correctly should be
able to flag or otherwise indicate that this is OK, and allow the
freeze to continue.  For other filesystems that do not handle
open-unlinked file consistency during a filesystem freeze/snapshot
whether this should even be considered a new case, or is something
that has existed for ages already.

The other question is whether this is still a problem even for
filesystems handling the consistency issue, but from Jan's comment
above there is a new locking issue related to mmap_sem being added?

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/





------------------------------------------------------------------------------
Better than sec? Nothing is better than sec when it comes to
monitoring Big Data applications. Try Boundary one-second 
resolution app monitoring today. Free.
http://p.sf.net/sfu/Boundary-dev2dev
