From: Jan Kara <jack@suse.cz>
Subject: Re: DRAFT Design Spec for 1st Class Quota Support in Ext4
Date: Mon, 26 Apr 2010 21:00:37 +0200
Message-ID: <20100426190036.GD21179@atrey.karlin.mff.cuni.cz>
References: <E1O6I3M-0002Wl-CV@closure.thunk.org> <87y6gad45r.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36184 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754293Ab0DZTAi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 15:00:38 -0400
Content-Disposition: inline
In-Reply-To: <87y6gad45r.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> "Theodore Ts'o" <tytso@mit.edu> writes:
> 
> > 2) The quota files will use the v2 format only, and updates to the quota
> > files will be protected with the journal if the journal is present.
> Since we are about to starting huge movements let's use new (v3) quota
> format. The only difference with v2 is extended header wider than old
> magic+version.
> 
> struct v3_disk_dqheader {
>         __le32 dqh_magic;        /* Magic number identifying file */
>         __le32 dqh_version;      /* File version */
>         __le32 dqh_state;        /* quota file  state */
>         __u32  dqh_reserved[125];
>  };
> dqh_state is an equivalent of sb's s_state.
  Dmitry, if you need new fields, add them to v?_disk_dqinfo. That is
designed for such things. Also the whole first quota block (1k) is reserved
for the header and the dqinfo structure so there's no need for the
dqh_reserved field.
  Now I guess you want the dqh_state to record that quota is inconsistent
due to some error or so. I'm OK with this but there's another option of
having this directly in the superblock. 

> > 6) Tune2fs will have a facility for adding and removing user and group
> > quotas inodes while the file system is mounted.  The quota usage will
> > not be correct after the quota inodes are newly added, however, so quota
> > will not be enabled by default,  If the quota inodes are removed, quota
> > will be disabled first.
>   Who is responsible for quota enabling in that scenario?
>   Will it enabled by default on mount time?
> 
> Small note: quotacheck -cug /mnt will result in unlink/create
> so we have options exclusive options:
> if inode is already exist
>   replace unlink/create with truncate
> else
>   call tune2fs from quotacheck after inodes was created.
  I guess I'll just make quotacheck refuse to work on an ext4 filesystem
with quota support. It's upto e2fsck to properly fill the quota information.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
