From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 23/51] e2fsck: Verify htree root/node checksums
Date: Mon, 19 Dec 2011 11:46:21 -0800
Message-ID: <20111219194621.GG8233@tux1.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011551.20947.72443.stgit@elm3c44.beaverton.ibm.com> <785BDE1C-35D8-4934-8FE0-F3EF54BDCEF0@whamcloud.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41251 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1LSTqc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 14:46:32 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 19 Dec 2011 14:46:31 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBJJkNrt067222
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 14:46:24 -0500
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBJJkM4j017246
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 12:46:23 -0700
Content-Disposition: inline
In-Reply-To: <785BDE1C-35D8-4934-8FE0-F3EF54BDCEF0@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 19, 2011 at 07:57:21AM +0100, Andreas Dilger wrote:
> On 2011-12-14, at 2:15, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> 
> > Check htree internal node checksums.  If broken, ask user to clear the htree
> > index and recreate it later.
> > 
> > @@ -560,8 +572,12 @@ static void parse_int_node(ext2_filsys fs,
> > #endif
> > 
> >    count = ext2fs_le16_to_cpu(limit->count);
> > -    expect_limit = (fs->blocksize - ((char *) ent - block_buf)) /
> > -        sizeof(struct ext2_dx_entry);
> > +    if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> > +                       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +        csum_size = sizeof(struct ext2_dx_tail);
> > +    expect_limit = (fs->blocksize -
> > +            (csum_size + ((char *) ent - block_buf))) /
> > +               sizeof(struct ext2_dx_entry);
> 
> How does this handle the case where the METADATA_CSUM feature is newly
> enabled but there is a dirent usinf the end of the leaf block?  It definitely
> shouldn't cause the last entry to be considered invalid. 

For htree nodes, tune2fs decrements limit if count < limit.  If count == limit,
then fsck is run to rebuild the htree index.  For its part, e2fsck will notice
that count == limit, zero the htree node, and add the directory inode to the
pass3 rebuild list.

> > @@ -829,7 +850,7 @@ static int check_dir_block(ext2_filsys fs,
> >               (rec_len == fs->blocksize) &&
> >               (dirent->name_len == 0) &&
> >               (ext2fs_le16_to_cpu(limit->limit) ==
> > -                ((fs->blocksize-8) /
> > +                ((fs->blocksize - (8 + csum_size)) /
> >                 sizeof(struct ext2_dx_entry))))
> >            dx_db->type = DX_DIRBLOCK_NODE;
> 
> Same here.  
> 
> > diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> > index 96b0de5..2e9ab7f 100644
> > --- a/e2fsck/problem.c
> > +++ b/e2fsck/problem.c
> > @@ -1374,6 +1374,16 @@ static struct e2fsck_problem problem_table[] = {
> >      N_("i_file_acl_hi @F %N, @s zero.\n"),
> >      PROMPT_CLEAR, PR_PREEN_OK },
> > 
> > +    /* htree root node fails checksum */
> > +    { PR_2_HTREE_ROOT_CSUM_INVALID,
> > +      N_("@p @h %d: root node fails checksum\n"),
> > +      PROMPT_CLEAR_HTREE, PR_PREEN_OK },
> > +
> > +    /* htree internal node fails checksum */
> > +    { PR_2_HTREE_NODE_CSUM_INVALID,
> > +      N_("@p @h %d: node fails checksum\n"),
> 
> This error message should include "internal" in the printed message. 

How about "htree node"?  I wondered why the other PR_*_HTREE messages don't say
"htree" -- is there a particular reason for this?

--D

