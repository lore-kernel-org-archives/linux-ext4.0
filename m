From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 19/28] mke2fs: add inline_data support in mke2fs
Date: Wed, 4 Dec 2013 13:21:50 +0800
Message-ID: <20131204052150.GG20409@gmail.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-20-git-send-email-wenqing.lz@taobao.com>
 <20131203223026.GI9535@birch.djwong.org>
 <20131204032757.GB11238@gmail.com>
 <20131204040819.GM9535@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48725 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab3LDFSz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Dec 2013 00:18:55 -0500
Received: by mail-pb0-f51.google.com with SMTP id up15so22859048pbc.10
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 21:18:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131204040819.GM9535@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 08:08:19PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 04, 2013 at 11:27:57AM +0800, Zheng Liu wrote:
> > On Tue, Dec 03, 2013 at 02:30:26PM -0800, Darrick J. Wong wrote:
> > [...]
> > > > +		 * notify users that inline data will never be useful.
> > > > +		 */
> > > > +		if ((fs_param.s_feature_incompat &
> > > > +		     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
> > > > +		    inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
> > > 
> > > Perhaps I'm missing something here, but why is it impossible to use i_blocks
> > > for inline data even if there's no space for EAs?
> > 
> > If I understand correctly, on kernel side, we determine an inode has
> > inline data according to whether we have 'system.data' xattr entry on
> > inode extended attribute space.  If an inode doesn't have enough space
> > to store an entry with 'system.data', we just think this inode doesn't
> > has inline data.  So that is why I add this sanity check.
> 
> Ok.  I was curious.  Small inode => no inline data seems like an unfortunate
> restriction to me, but oh well, it's your feature.  I don't plan to go back to
> 128 byte inodes ever. :)
> 
> Also, we could store four more bytes if we created a new e_name_index value (5?
> 9?) to represent "system.data".  Any thoughts about that?

Sorry, I don't get your point.  Do you want to create a new e_name_index?
Any reason lets you want to do this?

                                                - Zheng

> 
> --D
> 
> > 
> > Regards,
> >                                                 - Zheng
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
