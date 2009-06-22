From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Mon, 22 Jun 2009 09:42:25 -0700
Message-ID: <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com>
	 <20090617234604.GF7867@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:32834 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZFVQmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Jun 2009 12:42:25 -0400
Received: from zps75.corp.google.com (zps75.corp.google.com [172.25.146.75])
	by smtp-out.google.com with ESMTP id n5MGgRvo014890
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 09:42:27 -0700
Received: from pzk39 (pzk39.prod.google.com [10.243.19.167])
	by zps75.corp.google.com with ESMTP id n5MGfrFp006164
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 09:42:25 -0700
Received: by pzk39 with SMTP id 39so173094pzk.8
        for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2009 09:42:25 -0700 (PDT)
In-Reply-To: <20090617234604.GF7867@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted:

I think the following patch is sufficient.  It explicitly sets the aops=
 to
ext4_writeback_aops if there is no delayed allocation and no journal.

I tested the locale-gen example with all combinations of

   data=3Dwriteback
   data=3Dordered
   data=3Djournal
   <no journal at all>

and

   delalloc
   nodelalloc

and it works correctly now.  The paths for writeback seem fine to me fo=
r an
inode w/o a journal.


       Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
--- 2.6.26/fs/ext4/inode.c.orig	2009-06-09 20:05:27.000000000 -0700
+++ 2.6.26/fs/ext4/inode.c	2009-06-22 08:55:13.000000000 -0700
@@ -3442,15 +3442,12 @@ static const struct address_space_operat

 void ext4_set_aops(struct inode *inode)
 {
-	if (ext4_should_order_data(inode) &&
-		test_opt(inode->i_sb, DELALLOC))
+	if (test_opt(inode->i_sb, DELALLOC))
 		inode->i_mapping->a_ops =3D &ext4_da_aops;
 	else if (ext4_should_order_data(inode))
 		inode->i_mapping->a_ops =3D &ext4_ordered_aops;
-	else if (ext4_should_writeback_data(inode) &&
-		 test_opt(inode->i_sb, DELALLOC))
-		inode->i_mapping->a_ops =3D &ext4_da_aops;
-	else if (ext4_should_writeback_data(inode))
+	else if (ext4_should_writeback_data(inode) ||
+	                         EXT4_JOURNAL(inode) =3D=3D NULL)
 		inode->i_mapping->a_ops =3D &ext4_writeback_aops;
 	else
 		inode->i_mapping->a_ops =3D &ext4_journalled_aops;


On Wed, Jun 17, 2009 at 4:46 PM, Theodore Tso<tytso@mit.edu> wrote:
> Hi Curt,
>
> Thanks for your analysis of the bug. =A0The reason for the strange lo=
gic
> in ext4_set_aops() is because at the moment the code doesn't support
> the combination of data=3Djournalled && delalloc. =A0That's why it wa=
s
> explicitly checking for ext4_should_order_data() and
> ext4_should_writeback_data().
>
> We have a check for this in ext4_fill_super(), so your patch should b=
e
> safe, since the combination of ext4_should_journal_data &&
> test_opt(inode->i_sb, DELALLOC) should never happen.
>
> As to your question of whether the nodelalloc and nojournal case
> should really be ext4_journalled_aops, I suspect ext4_writeback_aops
> makes more sense. =A0I haven't audited all of the code paths to make
> sure they DTRT in the non-journalled case yet, though.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
