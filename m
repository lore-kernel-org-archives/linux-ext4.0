From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: [PATCH] Unify log messages in ext2
Date: Wed, 18 Nov 2009 20:26:07 +0100
Message-ID: <1258572367.2957.34.camel@mini>
References: <0EAA3AC5-9EB3-4547-AA50-0B601665B1C3@sun.com>
	 <1257406384-4457-1-git-send-email-bug-track@fisher-privat.net>
	 <1257519207.19442.10.camel@zwerg>
	 <20091117212314.GA26567@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44702 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758065AbZKRT0G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Nov 2009 14:26:06 -0500
In-Reply-To: <20091117212314.GA26567@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Am Dienstag, den 17.11.2009, 22:23 +0100 schrieb Jan Kara:
> Hi,
> 
>   overall I like the patch. A few comments are below. When you fix them,
> I can take care of merging the patch (please CC me on the posting so
> that I don't miss it in the mailing list).
> 
> > Am Donnerstag, den 05.11.2009, 08:33 +0100 schrieb Alexey Fisher:
> > > make messages produced by ext2 more unified. It should be
> > > easy to parse.
> > > 
> > > dmesg before patch:
> > > [ 4893.684892] reservations ON
> > > [ 4893.684896] xip option not supported
> > > [ 4893.684961] EXT2-fs warning: mounting ext3 filesystem as ext2
> > > [ 4893.684964] EXT2-fs warning: maximal mount count reached, running
> > > e2fsck is recommended
> > > [ 4893.684990] EXT II FS: 0.5b, 95/08/09, bs=1024, fs=1024, gc=2,
> > > bpg=8192, ipg=1280, mo=80010]
> > > 
> > > dmesg after patch:
> > > [ 4893.684892] EXT2-fs (loop0): reservations ON
> > > [ 4893.684896] EXT2-fs (loop0): xip option not supported
> > > [ 4893.684961] EXT2-fs (loop0): warning: mounting ext3 filesystem as
> > > ext2
> > > [ 4893.684964] EXT2-fs (loop0): warning: maximal mount count reached,
> > > running e2fsck is recommended
> > > [ 4893.684990] EXT2-fs (loop0): 0.5b, 95/08/09, bs=1024, fs=1024, gc=2,
> > > bpg=8192, ipg=1280, mo=80010]
> > > 
> > > Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
> > > Reviewed-by: Andreas Dilger <adilger@sun.com>
> > > ---
> > >  fs/ext2/ext2.h  |    2 +
> > >  fs/ext2/super.c |  151 +++++++++++++++++++++++++++++++------------------------
> > >  2 files changed, 88 insertions(+), 65 deletions(-)
> > > 
> > > diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> > > index 9a8a8e2..29f65c5 100644
> > > --- a/fs/ext2/ext2.h
> > > +++ b/fs/ext2/ext2.h
> > > @@ -142,6 +142,8 @@ struct dentry *ext2_get_parent(struct dentry *child);
> > >  /* super.c */
> > >  extern void ext2_error (struct super_block *, const char *, const char *, ...)
> > >  	__attribute__ ((format (printf, 3, 4)));
> > > +extern void ext2_msg(struct super_block *, const char *, const char *, ...)
> > > +	__attribute__ ((format (printf, 3, 4)));
> > >  extern void ext2_warning (struct super_block *, const char *, const char *, ...)
> > >  	__attribute__ ((format (printf, 3, 4)));
> > >  extern void ext2_update_dynamic_rev (struct super_block *sb);
> > > diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> > > index 1a9ffee..105fcd1 100644
> > > --- a/fs/ext2/super.c
> > > +++ b/fs/ext2/super.c
> > > @@ -58,26 +58,38 @@ void ext2_error (struct super_block * sb, const char * function,
> > >  	}
> > >  
> > >  	va_start(args, fmt);
> > > -	printk(KERN_CRIT "EXT2-fs error (device %s): %s: ",sb->s_id, function);
> > > +	ext2_msg(sb, KERN_CRIT, "error %s", function);
>   So this will be:
> EXT2-fs (sda6): error function_foo
> error message
>   Not quite what we want I think. Besides that I'd like a bit more
> messages like:
> EXT2-fs error (device): function: message
> 
> And for other warnings:
> EXT2-fs warning (device): function: message
> 
> It's still easy to parse by grep and IMHO nicer to read.

Hmm... there is currently 3 functions to inform user: ext2_error,
ext2_msg and ext2_warning

ext2_error used only on critical errors, so it will remount ro or panic
ext2_warning will print way you like "EXT2-fs warning (device):
function: message"
ext2_msg is sort all around, you can warn or inform but this do not
include __function__ and this will looks like: "EXT2-fs warning
(device): warning: message"

IMHO not all warnings need function to be printed, for example:
"warning: mounting unchecked fs, running e2fsck is recommended" so if i
use ext2_msg this looks like "EXT2-fs (sda6): warning: mounting
unchecked fs, running e2fsck is recommended"

So the question is: do we actually need print __function__ in warnings?
If not, we do not need ext2_warning but this will not look the way you
like ;)

instead of
EXT2-fs error (device): function: message
EXT2-fs warning (device): function: message

will be:
EXT2-fs (device): error: message 
EXT2-fs (device): warning: message
EXT2-fs (device): message

If we do ext2_warning we can make all messages consequent. Some of them
will use ext2_warning
EXT2-fs warning (device): function: message

and some ext2_msg
EXT2-fs (device): warning: message

> > > @@ -420,7 +432,7 @@ static const match_table_t tokens = {
> > >  };
> > >  
> > >  static int parse_options (char * options,
> > > -			  struct ext2_sb_info *sbi)
> > > +			  struct ext2_sb_info *sbi, struct super_block *sb)
> > >  {
> > >  	char * p;
> > >  	substring_t args[MAX_OPT_ARGS];
>   When you pass in 'sb', there's no need to pass in 'sbi' since than can
> be obtained as EXT2_SB(sb).
> 
> > >  cantfind_ext2:
> > >  	if (!silent)
> > > -		printk("VFS: Can't find an ext2 filesystem on dev %s.\n",
> > > -		       sb->s_id);
> > > +		ext2_msg(sb, KERN_ERR,
> > > +			"VFS: Can't find an ext2 filesystem");
> > >  	goto failed_mount;
>   This message will be strange:
> EXT2-fs (device): VFS: Can't find an ext2 filesystem
> 
>   I'd maybe drop the "VFS:" and leave "on dev ..." in the message. I
> know the device name will be duplicated but without that the sentence
> just doesn't quite make sence.
> 
> 								Honza

Alexey


