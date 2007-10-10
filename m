From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH, RFC 1/3] ext4_grpnum_t: Add new type
Date: Wed, 10 Oct 2007 11:42:43 +0200
Message-ID: <470C9E93.8050709@bull.net>
References: <4702E340.8070603@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57515 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbXJJJnB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2007 05:43:01 -0400
In-Reply-To: <4702E340.8070603@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Avantika Mathur wrote:
> Ext4: add new type ext4_grpnum_t, and change all group variables to t=
his=20
> type.
> from: mathur@us.ibm.com
> In many places variables for block group are of type int, which limit=
s the
> maximum filesystem size.  This patch introduces a new type
> ext4_grpnum_t, of type unsigned long, to represent block group number=
s=20
> in ext4.
> All occurrences of block group variables are converted to type=20
> ext4_grpnum_t.

Hi avantika,
Just one little thing, you forgot to convert a variable type in balloc.=
c:

ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
                     ext4_fsblk_t goal, unsigned long *count, int *errp=
)
{
         struct buffer_head *bitmap_bh =3D NULL;
         struct buffer_head *gdp_bh;
         ext4_grpnum_t group_no;
         ext4_grpnum_t goal_group;
         ext4_grpblk_t grp_target_blk;   /* blockgroup relative goal=20
block */
         ext4_grpblk_t grp_alloc_blk;    /* blockgroup-relative=20
allocated block*/
         ext4_fsblk_t ret_block;         /* filesyetem-wide allocated=20
block */
         int bgi;                        /* blockgroup iteration index =
*/
        ^^^^^


Could you also remove, at the same time, the useless lines in this func=
tion:
#ifdef EXT4FS_DEBUG
         static int goal_hits, goal_attempts;
#endif
=2E.. and:
         ext4_debug("allocating block %lu. Goal hits %d of %d.\n",
                         ret_block, goal_hits, goal_attempts);

Just to clean up the code.
Thanks,
   Val=E9rie
