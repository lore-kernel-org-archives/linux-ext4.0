From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [RFC PATCH 10/17] signed int -> blk64_t to fix bugs at 2^31 -	2^32 blocks
Date: Thu, 13 Nov 2008 21:38:12 -0500
Message-ID: <20081114023812.GD20637@shell>
References: <1226461390-5502-3-git-send-email-vaurora@redhat.com> <1226461390-5502-4-git-send-email-vaurora@redhat.com> <1226461390-5502-5-git-send-email-vaurora@redhat.com> <1226461390-5502-6-git-send-email-vaurora@redhat.com> <1226461390-5502-7-git-send-email-vaurora@redhat.com> <1226461390-5502-8-git-send-email-vaurora@redhat.com> <1226461390-5502-9-git-send-email-vaurora@redhat.com> <1226461390-5502-10-git-send-email-vaurora@redhat.com> <1226461390-5502-11-git-send-email-vaurora@redhat.com> <20081113195742.GV16005@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYKNCiN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2008 21:38:13 -0500
Content-Disposition: inline
In-Reply-To: <20081113195742.GV16005@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 12:57:42PM -0700, Andreas Dilger wrote:
> On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
> > diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
> > index 7235f7d..71ad445 100644
> > --- a/lib/ext2fs/alloc_tables.c
> > +++ b/lib/ext2fs/alloc_tables.c
> > @@ -147,7 +147,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
> > -		int prev_block = 0;
> > +		blk64_t prev_block = 0;
> 
> > @@ -178,7 +178,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
> >  	if (flexbg_size) {
> > -		int prev_block = 0;
> > +		blk64_t prev_block = 0;
> 
> These appear to be defects in the base code and should be landed ASAP
> (as int -> blk_t) independently of this patch series.

Agreed.  Ted, is this a good format for you or do you want me to
regenerate against something?

-VAL
