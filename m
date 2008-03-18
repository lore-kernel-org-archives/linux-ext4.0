From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, REWORKED 01/11] Add initial checksum support for the
	gdt_checksum/uninit_group feature
Date: Tue, 18 Mar 2008 08:26:16 +0800
Message-ID: <20080318002616.GG3542@webber.adilger.int>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
 <1205760527-14858-2-git-send-email-tytso@mit.edu>
 <20080317172254.GF3542@webber.adilger.int> <20080317180505.GG8368@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33244 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYCRA1P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 20:27:15 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2I0RE3N014067
	for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2008 17:27:14 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXW00L01H6WYN00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 17 Mar 2008 17:27:14 -0700 (PDT)
In-reply-to: <20080317180505.GG8368@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 17, 2008  14:05 -0400, Theodore Ts'o wrote:
> On Tue, Mar 18, 2008 at 01:22:54AM +0800, Andreas Dilger wrote:
> > On Mar 17, 2008  09:28 -0400, Theodore Ts'o wrote:
> > > +STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
>   ....
> > > +	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
> > > +		int offset = offsetof(struct ext2_group_desc, bg_checksum);
> > > +
>   ...
> > > +		offset += sizeof(desc->bg_checksum); /* skip checksum */
> > > +		assert(offset == sizeof(*desc));
> > 
> > Note that this assertion needs to be removed when the group descriptor
> > becomes larger, unless ext2_group_desc never changes in the future..
> 
> Yeah, I looked at this, and was half tempted to remove it.
> 
> Indeed ext2_group_desc will never change in the future.  Too many
> things would break if we change it.  That's why there is an
> ext4_group_desc which looks exactly like ext2_group_desc for the first
> 32 bytes, and adds the high 32-bits for the various fields in the
> second 32-bytes.
> 
> But if ext2_group_desc is never going to change, then there's no real
> good reason to use a run-time check here.  Better to turn it into a
> compile time check, using #error.  The tricky part is doing it in a
> way which is ANSI-C compliant (or maybe we just wrap it in a #ifdef
> GCC and only do the sanity check if you are compiling with GCC).

We have a compile-time assertion like:

/*
 * compile-time assertions. @cond has to be constant expression.
 * ISO C Standard:
 *
 *        6.8.4.2  The switch statement
 *
 *       ....
 *
 *       [#3] The expression of each case label shall be  an  integer
 *       constant   expression  and  no  two  of  the  case  constant
 *       expressions in the same switch statement shall have the same
 *       value  after  conversion...
 *       *
 */
#define CLASSERT(cond) ({ switch(42) { case (cond): case 0: break; } })

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

