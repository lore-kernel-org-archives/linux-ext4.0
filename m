From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext3: ext4: Using uninitialized value
Date: Wed, 13 Oct 2010 11:13:55 -0500
Message-ID: <4CB5DAC3.3040605@redhat.com>
References: <4CB5C4D6.3020201@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Roman Borisov <ext-roman.borisov@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab0JMQOB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Oct 2010 12:14:01 -0400
In-Reply-To: <4CB5C4D6.3020201@nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/13/2010 09:40 AM, Roman Borisov wrote:
> Hello,
> 
> Could you clarify is there a bug in fs/ext4/namei.c,
> ext4_dx_find_entry() and fs/ext4/namei.c, ext3_dx_find_entry()?

that was introduced with:

commit acfa1823d33859b0db77701726c9ca5ccc6e6f25
Author: Andreas Dilger <adilger@clusterfs.com>
Date:   Thu Jun 23 00:09:45 2005 -0700

    [PATCH] Support for dx directories in ext3_get_parent (NFSD)

so maybe Andreas knows offhand ;)  but I think:

> <code>
> static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
> ...
>         if (namelen > 2 || name[0] != '.'|| (namelen == 2 && name[1] != '.')) {

This is a fancy way of saying name is not "." or ".."

>                 if (!(frame = dx_probe(entry, dir, &hinfo, frames, err)))
>                         return NULL;
>         } else {

so here it -is- "." or ".." -

>                 frame = frames;
>                 frame->bh = NULL;                       /* for dx_release() */
>                 frame->at = (struct dx_entry *)frames;  /* hack for zero entry*/
>                 dx_set_block(frame->at, 0);             /* dx_root block is 0 */

now frame->at.block = 0

>         }
>         hash = hinfo.hash;
>         do {
>                 block = dx_get_block(frame->at);

block = 0 (we just put it there)

>                 if (!(bh = ext3_bread (NULL,dir, block, 0, err)))
>                         goto errout;

so we look up block 0 in the dir inode

>                 de = (struct ext3_dir_entry_2 *) bh->b_data;
>                 top = (struct ext3_dir_entry_2 *) ((char *) de + sb->s_blocksize -
>                                        EXT3_DIR_REC_LEN(0));

and get to the dir entry, and search through them for our name

>                 for (; de < top; de = ext3_next_entry(de)) {
>                         int off = (block << EXT3_BLOCK_SIZE_BITS(sb))
>                                   + ((char *) de - bh->b_data);
> 
>                         if (!ext3_check_dir_entry(__func__, dir, de, bh, off)) {
>                                 brelse(bh);
>                                 *err = ERR_BAD_DX_DIR;
>                                 goto errout;
>                         }
> 
>                         if (ext3_match(namelen, name, de)) {

here we should find the . or .. (it's always going to be there, right?)

>                                 *res_dir = de;
>                                 dx_release(frames);
>                                 return bh;

so we return

>                         }
>                 }

before we get here:

> ...
>                 retval = ext3_htree_next_block(dir, hash, frame,
>                                                frames, NULL);
> ...
> </code>

-Eric

> In the code above: hinfo.hash is not initialized in "else" case.
> Should it be initialized as NULL?
> Or maybe implementation doesn't assume to call ext3_htree_next_block()
> in such case?
> 
> Thanks,
> Roman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

