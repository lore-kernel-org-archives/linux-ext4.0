From: Marcus =?iso-8859-1?Q?H=FCwe?= <suse-tux@gmx.de>
Subject: Re: [PATCH] e2undo: fix endian issues
Date: Fri, 17 Jun 2016 09:24:56 +0200
Message-ID: <20160617072456.m3t2xopwomzcfcgm@linux>
References: <fe6468da-e719-2d83-579a-e8bab91c0a99@redhat.com>
 <20160616230510.GC5724@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62443 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbcFQHZE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jun 2016 03:25:04 -0400
Content-Disposition: inline
In-Reply-To: <20160616230510.GC5724@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2016-06-16 16:05:10 -0700, Darrick J. Wong wrote:
> On Thu, Jun 16, 2016 at 05:51:04PM -0500, Eric Sandeen wrote:
> > Two new e2undo issues exist in the latest release on big endian
> > machines.
> > 
> > From sparse check:
> > 
> > undo_io.c:157:26: warning: invalid assignment: |=
> > undo_io.c:157:26:    left side has type restricted __le32
> > undo_io.c:157:26:    right side has type int
> > undo_io.c:161:26: warning: invalid assignment: &=
> > undo_io.c:161:26:    left side has type restricted __le32
> > undo_io.c:161:26:    right side has type int
> > 
> > e2undo.c:211:16: warning: cast to restricted __le64
> > e2undo.c:211:16: warning: cast from restricted blk64_t
> > e2undo.c:212:16: warning: cast to restricted __le64
> > e2undo.c:212:16: warning: cast from restricted blk64_t
> > 
> > Addresses-RedHat-Bugzilla: 1344636
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
> > index f921218..776d5b8 100644
> > --- a/lib/ext2fs/undo_io.c
> > +++ b/lib/ext2fs/undo_io.c
> > @@ -154,11 +154,11 @@ struct undo_private_data {
> >  #define E2UNDO_FEATURE_COMPAT_FS_OFFSET 0x1	/* the filesystem offset */
> >  
> >  static inline void e2undo_set_feature_fs_offset(struct undo_header *header) {
> > -	header->f_compat |= E2UNDO_FEATURE_COMPAT_FS_OFFSET;
> > +	header->f_compat |= ext2fs_le32_to_cpu(E2UNDO_FEATURE_COMPAT_FS_OFFSET);
> >  }
> >  
> >  static inline void e2undo_clear_feature_fs_offset(struct undo_header *header) {
> > -	header->f_compat &= ~E2UNDO_FEATURE_COMPAT_FS_OFFSET;
> > +	header->f_compat &= ~ext2fs_le32_to_cpu(E2UNDO_FEATURE_COMPAT_FS_OFFSET);
> >  }
> 
> (I don't remember the fs_offset patch going to the list?)
> 
No, I sent it directly to Ted - but I was told to CC the list in the
future. Sorry for that...


Marcus
