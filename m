From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Enable delalloc and mballoc by default.
Date: Wed, 24 Oct 2007 12:15:01 -0700
Message-ID: <1193253301.4097.8.camel@localhost.localdomain>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <471F7F41.6080800@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39373 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXJXTPA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2007 15:15:00 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9OJGWPO015960
	for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2007 15:16:32 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9OJExWn104832
	for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2007 15:14:59 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9OJEwOE008957
	for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2007 15:14:59 -0400
In-Reply-To: <471F7F41.6080800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-10-24 at 12:22 -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> 
> > @@ -1279,6 +1280,9 @@ clear_qf_name:
> >  		case Opt_delalloc:
> >  			set_opt (sbi->s_mount_opt, DELALLOC);
> >  			break;
> 
> If delalloc, mballoc, extents are the new defaults, is there a reason to
> keep them as options?  When would you need to specify -o extents, now,
> for example? 
>  


For extents, personally I think we should make it default for ext4 and
remove this option.   But as far as I rememember, from one of prevous
the ext4 meeting, it was decided to make extents as default for ext4dev,
but for ext4 it was undecided.

For delayed allocation, before we have ordered mode support, we can't
make it default and still need this option.

> (though my brain is fuzzy today, maybe I'm missing
> something)  If this were not a filesystem ending in "dev" I could see
> keeping it for compatibility with existing fstabs....
> 
> > +		case Opt_nodelalloc:
> > +			clear_opt (sbi->s_mount_opt, DELALLOC);
> > +			break;
> >  		case Opt_mballoc:
> >  			set_opt(sbi->s_mount_opt, MBALLOC);
> >  			break;
> > @@ -1824,6 +1828,8 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
> >  	 * User -o noextents to turn it off
> >  	 */
> 
> I'd either update this comment ^^^^ or remove it, I think.
> 
> >  	set_opt(sbi->s_mount_opt, EXTENTS);
> > +	set_opt(sbi->s_mount_opt, DELALLOC);
> > +	set_opt(sbi->s_mount_opt, MBALLOC);
> >  
> >  	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
> >  			    NULL, 0))
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
