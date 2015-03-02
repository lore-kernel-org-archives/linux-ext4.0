From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsprogs: Limit number of reserved gdt blocks on small
 fs
Date: Mon, 2 Mar 2015 18:43:03 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1503021832080.30128@localhost.localdomain>
References: <1425056428-22598-1-git-send-email-lczerner@redhat.com> <54F48A7F.2090204@redhat.com> <alpine.LFD.2.00.1503021740510.30128@localhost.localdomain> <54F49D6F.7080509@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-414921804-1425318186=:30128"
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbbCBRnG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Mar 2015 12:43:06 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t22Hh6nS011390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Mon, 2 Mar 2015 12:43:06 -0500
In-Reply-To: <54F49D6F.7080509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-414921804-1425318186=:30128
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Mon, 2 Mar 2015, Eric Sandeen wrote:

> Date: Mon, 02 Mar 2015 11:27:11 -0600
> From: Eric Sandeen <sandeen@redhat.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] e2fsprogs: Limit number of reserved gdt blocks on small
>     fs
> 
> On 3/2/15 11:08 AM, Lukáš Czerner wrote:
> > On Mon, 2 Mar 2015, Eric Sandeen wrote:
> 
> ...
> 
> >> Some extra "making sure" in the above sentence.  ;)
> > 
> > Right, I'll fix that.
> > 
> >>
> >>>                    reserved_gdt_blocks is small enough. If the user
> >>> +	 * specifies non-default values he can still run into this issue
> >>> +	 * but we do not want to make that mistake by default.
> >>> +	 *
> >>> +	 * Magic numbers:
> >>> +	 * - At block count smaller than 32768, journal will be 1024 block
> >>> +	 *   blocks long which would not be enough by default.
> >>> +	 * - 64 reserved gtd blocks is maximum number we can fit into said
> >>
> >> gtd?  (gdt?  gdb?)
> > 
> > Oh yes...
> > 
> > I'll try to use it consistently.
> 
> thanks :)
> 
> >>
> >>> +	 *   journal by default (flex_bg_count * 4 + rsv_gdb)
> >>
> >> This is a little confusing; "flex_bg_count" isn't a thing, and it seems to
> >> say that the reserved blocks depend on the number of reserved blocks?
> > 
> > Does it ? It says that number of journal credits depend on the
> > number of reserved gdt blocks, or maybe I am missing something.
> > 
> > flex_bg_count is a number of groups in flex group, I'll try to come
> > up with a better name.
> 
> It just looks like a variable name; it's one that doesn't exist, so it's
> not clear what you're talking about.
> 
> >>
> >> I'm curious, why does this matter only for 1k blocks, and not, say 2k blocks?
> > 
> > That's because of the way we compute the number of reserved GDT
> > blocks. The number of GDT blocks depends on the number of block
> > groups, which depends on the number of blocks in the file system.
> > And with 1k file system we have much more blocks. In fact we have:
> > 
> > - twice as many blocks as with 2k file system
> > - four times the block groups
> > 
> > And we can also fit only half of the number of group descriptors
> > into a single block which means that we need twice as many blocks
> > per block group.
> > 
> > Which means that with 1k file system we need 8 times as many gdt
> > blocks as with 2k fs and 2048 times more gdt blocks as with 4k with
> > the same setup.
> > 
> >>
> >>> +	 */
> >>> +	if ((fs->blocksize == 1024) && (ext2fs_blocks_count(sb) < 32768) &&
> >>> +	    (rsv_gdb > 64))
> >>> +		rsv_gdb = 64;
> >>> +
> >>>  	if (rsv_gdb > EXT2_ADDR_PER_BLOCK(sb))
> >>>  		rsv_gdb = EXT2_ADDR_PER_BLOCK(sb);
> >>>  #ifdef RES_GDT_DEBUG
> >>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> >>> index aeb852f..e9edd3b 100644
> >>> --- a/misc/mke2fs.c
> >>> +++ b/misc/mke2fs.c
> >>> @@ -3076,6 +3076,34 @@ int main (int argc, char *argv[])
> >>>  		}
> >>>  		if (!quiet)
> >>>  			printf("%s", _("done\n"));
> >>> +
> >>> +		/*
> >>> +		 * In online resize we require a huge number of journal
> >>> +		 * credits mainly because of the reserved_gdt_blocks. The
> >>> +		 * exact number of journal credits needed is:
> >>> +		 * flex_gd->count * 4 + reserved_gdb
> >>> +		 *
> >>> +		 * Warn user if we will not have enough credits to resize
> >>> +		 * the file system online.
> >>> +		 */
> >>> +		if (fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE)
> >>> +		{
> >>> +			unsigned int credits;
> >>> +
> >>> +			/*
> >>> +			* This is the amount we're allowed to use for a
> >>> +			* single handle in a transaction
> >>> +			*/
> >>> +			journal_blocks /= 8;
> >>
> >> This seems a little dangerous; if someone decides to use journal_blocks
> >> later in the function, it might be unexpectedly smaller.
> >>
> >>> +			credits = (1 << fs_param.s_log_groups_per_flex) * 4 +
> >>> +				  fs->super->s_reserved_gdt_blocks;
> >>> +			if (credits > journal_blocks) {
> >>
> >> so maybe just scale this by 8, i.e. "if (credits > journal_blocks/8)"
> > 
> > Fair enough, I'll change that.
> > 
> >>
> >> And actually, I find myself wondering if this same calculation can be used
> >> in calc_reserved_gdt_blocks, rather than using the magic numbers?
> > 
> > Unfortunately it can not. At the time we're calculating number of gdt
> > blocks we have no idea how big the journal will be.
> > 
> > And at the time we already know how big the journal will be we
> > already have blocks allocated for the resize_inode so we can not
> > just simply change s_reserved_gdt_blocks here.
> 
> Ugh.  That sounds like a mess.
> 
> But it feels like we need centralized functions or macros that express the
> relationships between these values, rather than sprinkling "* 4" and "if 1024"
> around.  It seems to have the potential to get out of sync, but I've only
> given it cursory thought...

Yes, but that would require huge amount of rewrite I think. Mostly
we're trying to think of the dependencies between various file
system features and/or parameters. I think it's mostly in main() and
PRS() functions however this "dependency" is entirely unexpected.

I tried to think about a better way where to put it, but this is what
I came with. However maybe we can determine the journal size by
ext2fs_default_journal_size() and use the default journal size
instead ?

-Lukas

> 
> -Eric
> 
--8323328-414921804-1425318186=:30128--
