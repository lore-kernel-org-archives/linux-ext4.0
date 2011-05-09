From: Jan Kara <jack@suse.cz>
Subject: Re: mounting ext3 with another superblock doesn't work?
Date: Mon, 9 May 2011 14:06:08 +0200
Message-ID: <20110509120608.GK4122@quack.suse.cz>
References: <031c613316176c32f09748706a086be2@imap.dd24.net>
 <23AF51ED-8130-4401-94FE-93CF36E8E1C1@dilger.ca>
 <6f43bed530a6412344f7b30e42a89d23@imap.dd24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	adilger@dilger.ca, amir73il@users.sourceforge.net
To: Christoph Anton Mitterer <calestyo@scientia.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6f43bed530a6412344f7b30e42a89d23@imap.dd24.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

On Sat 07-05-11 22:03:39, Christoph Anton Mitterer wrote:
> What I did then yesterday night, was a
> 
> fsck.ext3 -b 32768 -B4096 device
> 
> There were MANY errors... (nearly all of them, that wouldn't be
> automatically corrected e.g. by -p).
> 
> 
> "Something" actually came back, though I cannot say (and probably never
> will, as there are millions) whether everything came back and/or whether
> the files are internally corrupted.
> 
> The problem is that the old directory structure was not recovered, but
> _everything_ went into lost+found, some files directly in it (not with
> their correct names but #xxxxxx numbers) and also many directories (also
> with #xxxxxx numbers as names).
> The directories however do contain at least some subtrees of the original
> filesystem hierarchy (I mean with the correct names).
> 
> I guess there's no (automatic) way now, to get the full directory
> structure as before, is there?
  No, not really. Actually, contents of the files should be generally OK
because mkfs overwrites only inodes. So you have lost some files and
directories but once you have a file, it should be OK.

> Of course I have some backups but unfortunately dating back to last
> October (yes, I know, I'm stupid and deserved it ^^)...
> 
> Will try now to use fdupes and/or rdfind, to sort out all files that are
> equal between backup and rescue fs and manually check and move back the
> others (a work of some months probably ^^).
> 
> It's not that I wanna blame others (I mean being stupid is my fault), but
> e2fsprogs' mkfs is really missing a check whether any known
> filesystem/partition type/container (luks, lvm, mdadm, etc.) is already on
> device (and a -force switch),... IIRC xfsprogs already do this more or
> less.
  Yes, that would be reasonable although it might break some people's
scripts. But probably worth it anyway.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
