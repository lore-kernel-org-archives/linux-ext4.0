From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: [PATCH] mke2fs reserved_ratio default value is nonsensical
Date: Tue, 29 Mar 2011 08:41:14 +0200
Message-ID: <20110329064114.GD27142@bitwizard.nl>
References: <AANLkTi=7jMS=yq4-72_CvcyGHuWWV6ixEKtk501wnxUz@mail.gmail.com> <4D90CE41.4030209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Oren Elrad <elrad@brandeis.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:39422 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1750774Ab1C2GlQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 02:41:16 -0400
Content-Disposition: inline
In-Reply-To: <4D90CE41.4030209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 28, 2011 at 01:06:57PM -0500, Eric Sandeen wrote:
> On 3/28/11 1:02 PM, Oren Elrad wrote:
> > Undesired behavior; mke2fs defaults to reserving 5% of the volume for
> > the root user. 5% of a 2TB volume is 100GB. The rationale for root
> > reservation (syslogd, etc...) does not require 100GB. As volumes get
> > larger, this default makes less and less sense.
> > 
> > Proposal; If the user does not specify their preferred reserve_ratio
> > on the command-line (-m), use the less of 5% or MAX_RSRV_SIZE. I
> > propose 10GiB as a sensible maximum default reservation for root.
> > 
> > Patch: Follows and http://capsid.brandeis.edu/~elrad/e2fsprog.gitdiff
> > 
> > Tested on the latest git+patch, RHEL5 (2.6.18-194.17.1.el5) with a
> > 12TB volume (which would reserve 600GB under the default!):
> 
> There's been a bit of debate about this; is the space really saved
> for root, or is it to stop the allocator from going off the rails
> when the fs nears capacity?  Both, really.
> 
> I don't really have a horse in the race, but the complaint has certainly
> come up before... it's just important to realize that the space isn't 
> only there for root's eventual use.
> 
> No other fs that I know of enforces this "don't fill the fs to capacity" 
> common sense programatically, though.

That could very well be because other filesystems don't much have the
big penalty that unix-like filesystems have when the fs fills to
capacity.

The effect shows I think on my work-filesystem: There mkdir now takes
tens of milliseconds instead of microseconds. That sort of performance
degradation should be prevented by a 5 or 10% free-space buffer. 

The idea is that if most block groups are filled to 95%, you'll have a
block group with free space nearby, so searching for free blocks will
always be fast.

On the other extreme: if 95% of the block groups are completely full,
the other 5% of block groups will be completely empty. So you'll have
no trouble finding free space there.

Eric has a patch to fix my mkdir troubles (hopefully) which I can't
test because I have production data there. And it's too much to run
backups. I have therefore been forced to choose "use RAID5" as the
data security policy for that data. (which is an improvement over "use
RAID0" which we used until a year ago or so).

It is a conscious choice, because besides that we would like to keep
the data, we NEED it to be fast as well. (and on the other hand, we
can't invest lots of money).

	Roger. 



> 
> -Eric
> 
> > # /root/e2fsprogs/misc/mke2fs -T ext4 -L scratch /dev/sdd1
> > [...]
> > OS type: Linux
> > Block size=4096 (log=2)
> > Fragment size=4096 (log=2)
> > Stride=0 blocks, Stripe width=0 blocks
> > 732422144 inodes, 2929671159 blocks
> > 2621440 blocks (0.09%) reserved for the super user
> > [...]
> > 
> > Oren Elrad
> > Dept. of Physics
> > Brandeis University
> > 
> > ---- Patch follows ----
> > 
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index 9798b88..0ff3785 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -108,6 +108,8 @@ profile_t	profile;
> >  int sys_page_size = 4096;
> >  int linux_version_code = 0;
> > 
> > +static const unsigned long long MAX_RSRV_SIZE = 10ULL * (1 << 30); // 10 GiB
> > +
> >  static void usage(void)
> >  {
> >  	fprintf(stderr, _("Usage: %s [-c|-l filename] [-b block-size] "
> > @@ -1154,7 +1156,7 @@ static void PRS(int argc, char *argv[])
> >  	int		inode_ratio = 0;
> >  	int		inode_size = 0;
> >  	unsigned long	flex_bg_size = 0;
> > -	double		reserved_ratio = 5.0;
> > +	double		reserved_ratio = -1.0; // Default: lesser of 5%, MAX_RSRV_SIZE
> >  	int		lsector_size = 0, psector_size = 0;
> >  	int		show_version_only = 0;
> >  	unsigned long long num_inodes = 0; /* unsigned long long to catch
> > too-large input */
> > @@ -1893,9 +1895,17 @@ profile_error:
> > 
> >  	/*
> >  	 * Calculate number of blocks to reserve
> > +	 * If reserved_ratio >= 0.0, it was passed as an argument, use it as-is
> > +	 * If reserved_ratio < 0.0, no argument was passed, choose the
> > lesser of 5%, MAX_RSRV_SIZE
> >  	 */
> > -	ext2fs_r_blocks_count_set(&fs_param, reserved_ratio *
> > -				  ext2fs_blocks_count(&fs_param) / 100.0);
> > +	if ( reserved_ratio >= 0.0 ) {
> > +		ext2fs_r_blocks_count_set(&fs_param, reserved_ratio *
> > +					  ext2fs_blocks_count(&fs_param) / 100.0);
> > +	} else {
> > +		const blk64_t r_blk_count = ext2fs_blocks_count(&fs_param) / 20.0;
> > +		const blk64_t max_r_blk_count = MAX_RSRV_SIZE / blocksize;
> > +		ext2fs_r_blocks_count_set(&fs_param, (r_blk_count < max_r_blk_count
> > ? r_blk_count : max_r_blk_count));
> > +	}
> >  }
> > 
> >  static int should_do_undo(const char *name)
> > 
> > By making a contribution to this project, I certify that:
> > 
> > 	(a) The contribution was created in whole or in part by me and I
> >             have the right to submit it under the open source license
> >             indicated in the file;
> > 
> > 	(d) I understand and agree that this project and the contribution
> > 	    are public and that a record of the contribution (including all
> > 	    personal information I submit with it, including my sign-off) is
> > 	    maintained indefinitely and may be redistributed consistent with
> > 	    this project or the open source license(s) involved.
> > 
> > Signed-off-by: Oren M Elrad <elrad@brandeis.edu>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
