From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH]: ext4: fix big endian
Date: Thu, 6 Nov 2008 17:15:53 +0100
Message-ID: <200811061715.53593.borntraeger@de.ibm.com>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Peter Staubach <staubach@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:53443 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYKFQRD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 11:17:03 -0500
In-Reply-To: <49131601.50407@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Donnerstag, 6. November 2008 schrieb Peter Staubach:
> >  	/* We allocate both existing and potentially added groups */
> >  	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
> > -			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
> > +			    (le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks + 1) <<
> >   
> 
> I suspect that you want to do the le16_to_cpu() and _then_
> add the 1.  Otherwise, adding 1 to a different byte order
> value won't do quite what is expected or hoped for...

errm. Right.
Something like this maybe?

[PATCH]: ext4: fix big endian access for flex groups

On big endianess plattforms newly created ext4 file systems cannot be mounted
and show messages like:
[6923911.715968] EXT4-fs: not enough memory for 522250 flex groups
[6923911.715973] EXT4-fs: unable to initialize flex_bg meta info!

We have to access s_reserved_gdb_blocks with le16_to_cpu.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: kvm/fs/ext4/super.c
===================================================================
--- kvm.orig/fs/ext4/super.c
+++ kvm/fs/ext4/super.c
@@ -1455,8 +1455,8 @@ static int ext4_fill_flex_info(struct su
 
 	/* We allocate both existing and potentially added groups */
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
-			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
-			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
+			    ((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) +
+			      1) << EXT4_DESC_PER_BLOCK_BITS(sb))) /
 			   groups_per_flex;
 	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
