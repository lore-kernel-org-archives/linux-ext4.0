From: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: mounting ext3 with another superblock doesn't =?UTF-8?Q?work=3F?=
Date: Sat, 07 May 2011 22:03:39 +0000
Message-ID: <6f43bed530a6412344f7b30e42a89d23@imap.dd24.net>
References: <031c613316176c32f09748706a086be2@imap.dd24.net> <23AF51ED-8130-4401-94FE-93CF36E8E1C1@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: <linux-ext4@vger.kernel.org>, <adilger@dilger.ca>,
	<amir73il@users.sourceforge.net>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <23AF51ED-8130-4401-94FE-93CF36E8E1C1@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi folks.

What I did then yesterday night, was a

fsck.ext3 -b 32768 -B4096 device

There were MANY errors... (nearly all of them, that wouldn't be
automatically corrected e.g. by -p).


"Something" actually came back, though I cannot say (and probably never
will, as there are millions) whether everything came back and/or whether
the files are internally corrupted.

The problem is that the old directory structure was not recovered, but
_everything_ went into lost+found, some files directly in it (not with
their correct names but #xxxxxx numbers) and also many directories (also
with #xxxxxx numbers as names).
The directories however do contain at least some subtrees of the original
filesystem hierarchy (I mean with the correct names).

I guess there's no (automatic) way now, to get the full directory
structure as before, is there?


Of course I have some backups but unfortunately dating back to last
October (yes, I know, I'm stupid and deserved it ^^)...

Will try now to use fdupes and/or rdfind, to sort out all files that are
equal between backup and rescue fs and manually check and move back the
others (a work of some months probably ^^).


It's not that I wanna blame others (I mean being stupid is my fault), but
e2fsprogs' mkfs is really missing a check whether any known
filesystem/partition type/container (luks, lvm, mdadm, etc.) is already on
device (and a -force switch),... IIRC xfsprogs already do this more or
less.


Thanks and cheers,
Chris.
