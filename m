From: Jan Kara <jack@suse.cz>
Subject: Re: mounting ext3 with another superblock doesn't work?
Date: Mon, 9 May 2011 15:10:27 +0200
Message-ID: <20110509131027.GM4122@quack.suse.cz>
References: <031c613316176c32f09748706a086be2@imap.dd24.net>
 <23AF51ED-8130-4401-94FE-93CF36E8E1C1@dilger.ca>
 <6f43bed530a6412344f7b30e42a89d23@imap.dd24.net>
 <20110509120608.GK4122@quack.suse.cz>
 <1304945969.11788.14.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1304945969.11788.14.camel@heisenberg.scientia.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 09-05-11 14:59:29, Christoph Anton Mitterer wrote:
> On Mon, 2011-05-09 at 14:06 +0200, Jan Kara wrote:
> > Actually, contents of the files should be generally OK
> > because mkfs overwrites only inodes. So you have lost some files and
> > directories but once you have a file, it should be OK.
> This is really some good news!! :-)
> Are you sure with that? And wouldn't mean, that inodes are always
> located at the same block locations?
  Well, the block size is most likely the same (4 KB) in both the old and
the new fs (unless you tinkered with it but I don't expect that). That
defines size of a block group and thus position of inodes, bitmaps, etc.
Another variable is a number of inodes (per group). If you have an old
superblock you can compare the old and the new number of inodes and you
can be sure. Otherwise you rely on whether the math in the mkfs with which
you've originally created the fs is the same as the math in your current
mkfs (and you didn't specify any special options regarding this)...

								Honza
 
> > > It's not that I wanna blame others (I mean being stupid is my fault), but
> > > e2fsprogs' mkfs is really missing a check whether any known
> > > filesystem/partition type/container (luks, lvm, mdadm, etc.) is already on
> > > device (and a -force switch),... IIRC xfsprogs already do this more or
> > > less.
> >   Yes, that would be reasonable although it might break some people's
> > scripts. But probably worth it anyway.
> IMHO the breakage is really justified then :-)
> 
> Especially as some of those scripts might actually do their own checks
> for some filesystems, but perhaps completely forget about other
> containter types (partitions, LUKS, mdadm, etc. etc.)
> 
> 
> Cheers,
> Chris.
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
