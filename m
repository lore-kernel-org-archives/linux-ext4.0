From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Mon, 11 Aug 2014 22:16:05 +0800
Message-ID: <CAPTn0cBAYxCX0w3uiT1FLi2Nw4R+AFj2whouD4jr5tbZsFqaUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>,
	Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>   So I actually don't think project quota as implemented by XFS (and with
> which me and Ted want to stay compatible with) isn't different from what you
> want. Let me explain what XFS does:
>   1) Each file has an additional ID - the project ID
>   2) Each dir can have XFS_DIFLAG_PROJINHERIT flag set. When this flag is
>      set, all files and directories created in the directory inherit project
>      ID, directories also inherit XFS_DIFLAG_PROJINHERIT - this is
>      equivalent of sgid bit on directories for gids.
>   3) When you hard-link a file into directory with XFS_DIFLAG_PROJINHERIT
>      set, the file already has to have the same project ID as the directory
>      you are linking into.
>   4) When you rename a file into a directory with XFS_DIFLAG_PROJINHERIT
>      set, the file already has to have the same project ID as the directory
>      you are renaming into.
>   5) If you call statfs() on a directory with XFS_DIFLAG_PROJINHERIT set
>      and project quota is being enforced, statfs() will return free/used
>      blocks of the corresponding project instead of number of free/used
>      blocks in the filesystem.
>
> Now if, as an administrator, you decide you need completely generic
> additional ID, you can do so. You just never set XFS_DIFLAG_PROJINHERIT.
> Quota accounting and enforcement works just fine without that flag.
>
> So the discussion really is about the semantics of the
> XFS_DIFLAG_PROJINHERIT flag. If you want automatic inheritance of project
> ids, you set XFS_DIFLAG_PROJINHERIT.  With that you'll get additional
> limitations described in 3) and 4). And I am of the opinion that these
> limitations help to maintain sanity in a system where project quotas are
> used. I can imagine XFS_DIFLAG_PROJINHERIT would be split in two flags
> for ext4 - one controlling whether project ID is inherited, another
> controlling whether we enforce rules 3) and 4) but such difference from XFS
> would have to be very well justified because different filesystems having
> subtly different semantics is a real administrative nightmare, much worse
> than the additional cp + unlink done when rename() returns EXDEV because
> you tried to rename from one project to another.
Thank you so much for your detailed introduction! I didn't know there
is a tunable
XFS_DIFLAG_PROJINHERIT flag and I thought that rule 3) and 4) always
took effect. I would like to keep everything compatible with XFS if
this flag can
turn on/off rule 3) and 4) freely. I will check the implement details of XFS in
case of making similar mistakes.

Regards,
Li Xi
