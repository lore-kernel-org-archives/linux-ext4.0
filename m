From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: mounting ext3 with another superblock doesn't work?
Date: Mon, 9 May 2011 15:18:20 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105091513320.3694@dhcp-27-109.brq.redhat.com>
References: <031c613316176c32f09748706a086be2@imap.dd24.net>  <23AF51ED-8130-4401-94FE-93CF36E8E1C1@dilger.ca>  <6f43bed530a6412344f7b30e42a89d23@imap.dd24.net>  <20110509120608.GK4122@quack.suse.cz> <1304945969.11788.14.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1304945969.11788.14.camel@heisenberg.scientia.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 9 May 2011, Christoph Anton Mitterer wrote:

> On Mon, 2011-05-09 at 14:06 +0200, Jan Kara wrote:
> > Actually, contents of the files should be generally OK
> > because mkfs overwrites only inodes. So you have lost some files and
> > directories but once you have a file, it should be OK.
> This is really some good news!! :-)
> Are you sure with that? And wouldn't mean, that inodes are always
> located at the same block locations?
> 
> 
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

Well, it really is not justified!. We all have testing scripts where we
just create filesystem over and over again because it is how it works,
consider xfstests for example, there are even some tests which clears
MKFS_OPTIONS completely (which should be fixet btw).

However I do agree that the change should be made, but we should
probably just print an warning first and then after some time, when
people notice that something is going to change, make that change to
refuse mkfs on existing filesystem without "-F" option.

Thanks!
-Lukas

> 
> 
> Cheers,
> Chris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
