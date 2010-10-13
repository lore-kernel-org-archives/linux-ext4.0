From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext3: ext4: Using uninitialized value
Date: Wed, 13 Oct 2010 12:56:33 -0600
Message-ID: <0E811115-22DB-4D20-AE03-428037E1429C@dilger.ca>
References: <4CB5C4D6.3020201@nokia.com> <4CB5DAC3.3040605@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Roman Borisov <ext-roman.borisov@nokia.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:31159 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0JMS4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Oct 2010 14:56:35 -0400
In-Reply-To: <4CB5DAC3.3040605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-13, at 10:13, Eric Sandeen wrote:
> On 10/13/2010 09:40 AM, Roman Borisov wrote:
>> Hello,
>> 
>> Could you clarify is there a bug in fs/ext4/namei.c,
>> ext4_dx_find_entry() and fs/ext4/namei.c, ext3_dx_find_entry()?
> 
> that was introduced with:
> 
> commit acfa1823d33859b0db77701726c9ca5ccc6e6f25
> Author: Andreas Dilger <adilger@clusterfs.com>
> Date:   Thu Jun 23 00:09:45 2005 -0700
> 
>   [PATCH] Support for dx directories in ext3_get_parent (NFSD)
> 
> so maybe Andreas knows offhand ;)  but I think:

Your analysis is correct.  I agree it's a bit convoluted, but it avoids replicating a bunch of code.

>> static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
>> ...
>>       if (namelen > 2 || name[0] != '.'|| (namelen == 2 && name[1] != '.'))
>>        } else {
> 
> so here it -is- "." or ".." -
> 
>>               frame = frames;
>>               frame->bh = NULL;                       /* for dx_release() */
>>               frame->at = (struct dx_entry *)frames;  /* hack for zero entry*/
>>               dx_set_block(frame->at, 0);             /* dx_root block is 0 */
>>               if (!(bh = ext3_bread (NULL,dir, block, 0, err)))
>>                       goto errout;
> 
> so we look up block 0 in the dir inode
> 
>>                       if (ext3_match(namelen, name, de)) {
> 
> here we should find the . or .. (it's always going to be there, right?)

Right - it is important to note that the index root block is a "fake" directory block which has just the "." and ".." entries at the beginning (with the ".." spanning the rest of the block), and the rest of the block is holding the index entries.  For a directory index to even exist, it HAS to have the "." and ".." entries in the first block, or there is no place to put the index.

Cheers, Andreas





