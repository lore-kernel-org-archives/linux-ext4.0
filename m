From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] libblki: fix s_feature_compat usage
Date: Tue, 16 Sep 2008 01:36:43 +0200
Message-ID: <20080915233643.GA5617@nb.net.home>
References: <1221480209-982-1-git-send-email-kzak@redhat.com> <20080915231102.GE3241@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbYIOXgs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Sep 2008 19:36:48 -0400
Content-Disposition: inline
In-Reply-To: <20080915231102.GE3241@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 15, 2008 at 04:11:02PM -0700, Andreas Dilger wrote:
> On Sep 15, 2008  14:03 +0200, Karel Zak wrote:
> > Note that this patch also fix minor coding still errors.

 oops, s/still/style/ :-(

> > @@ -150,7 +150,7 @@ static void get_ext2_info(blkid_dev dev, struct blkid_magic *id,
> >  
> >  	set_uuid(dev, es->s_uuid, 0);
> >  
> > -	if ((es->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
> > +	if ((blkid_le32(es->s_feature_compat) & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
> 
> Minor note - it is generally preferable to swab the constant value,

 probably yes, but see the rest of the library code... :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
