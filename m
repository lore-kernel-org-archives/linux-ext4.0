From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: disable defrag for metadata_csum file systems
Date: Thu, 18 Apr 2013 22:47:38 -0700
Message-ID: <20130419054738.GA5617@blackbox.djwong.org>
References: <1366322282-4673-1-git-send-email-tytso@mit.edu>
 <51707E06.2050105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31814 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3DSFrp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Apr 2013 01:47:45 -0400
Content-Disposition: inline
In-Reply-To: <51707E06.2050105@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 19, 2013 at 07:13:10AM +0800, Zheng Liu wrote:
> [Sorry, it seems that I got a delivery error.  So send again]
> 
> On 04/19/2013 05:58 AM, Theodore Ts'o wrote:
> > It looks like there is absolutely no support for metadata checksums in
> > fs/ext4/move_extent.c.  So if you try to defrag a file on a
> > metadata_csum, it leaves the file system corrupted.
> > 
> > We really, really should get this fixed ASAP, but until we do, let's
> > disable e4defrag on metadata_csum file systems so we avoid corrupting
> > file systems.
> > 
> > Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Yes, I also notice this problem.  So currently it seems that the best
> choice is to disable defrag for metadata_csum.

I think this happens because mext_insert_extents() open-codes the metadata
dirtying and forgets to update the extent block header.  It should call
ext4_ext_dirty() at the end, instead. :(

I should see if there are any other sites that dirty metadata without making
the proper csum_set calls.  Will send a fix shortly, so NAK.

--D
> 
> Reviewed-By: Zheng Liu <wenqing.lz@taobao.com>
> 
> Thanks,
> 						- Zheng
> 
> > ---
> >  fs/ext4/ioctl.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> > index 9491ac0..2d043da 100644
> > --- a/fs/ext4/ioctl.c
> > +++ b/fs/ext4/ioctl.c
> > @@ -450,6 +450,15 @@ group_extend_out:
> >  			goto mext_out;
> >  		}
> >  
> > +		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> > +			ext4_msg(sb, KERN_ERR,
> > +				 "Online defrag not supported with "
> > +				 "metadata_csum");
> > +			err = -EOPNOTSUPP;
> > +			goto mext_out;
> > +		}
> > +
> >  		err = mnt_want_write_file(filp);
> >  		if (err)
> >  			goto mext_out;
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
