From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Enable delalloc and mballoc by default.
Date: Wed, 24 Oct 2007 15:06:39 -0600
Message-ID: <20071024210639.GC26078@webber.adilger.int>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <471F7F41.6080800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:60899 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207AbXJXVGl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 17:06:41 -0400
Content-Disposition: inline
In-Reply-To: <471F7F41.6080800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 24, 2007  12:22 -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > @@ -1279,6 +1280,9 @@ clear_qf_name:
> >  		case Opt_delalloc:
> >  			set_opt (sbi->s_mount_opt, DELALLOC);
> >  			break;
> 
> If delalloc, mballoc, extents are the new defaults, is there a reason to
> keep them as options?  When would you need to specify -o extents, now,
> for example?  (though my brain is fuzzy today, maybe I'm missing
> something)  If this were not a filesystem ending in "dev" I could see
> keeping it for compatibility with existing fstabs....

It is useful to be able to mount w/o extents/delalloc/mballoc for perf
testing and functional testing of the block-mapped file path in ext4.
Also, some users might want the ability to use features of ext4 w/o
the incompatibility of extents.

> >  	set_opt(sbi->s_mount_opt, EXTENTS);
> > +	set_opt(sbi->s_mount_opt, DELALLOC);
> > +	set_opt(sbi->s_mount_opt, MBALLOC);

I think the other thing to do is enable the INCOMPAT_EXTENTS flag in
mkfs.ext4 by default, so that extents is enabled/disabled in the
same manner as other ext* features.  We can remove the above once
we have an e2fsprogs that specifically sets all of the ext4 features
(large inodes, etc) for ext4 filesystems.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
