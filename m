From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: "data=writeback" and TRIM don't get along
Date: Wed, 07 Apr 2010 23:10:40 -0500
Message-ID: <4BBD5740.4070101@redhat.com>
References: <4BBD285B.9000603@gmail.com> <4BBD2FDF.4040407@redhat.com> <4BBD3365.90306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0DHEKp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 00:10:45 -0400
In-Reply-To: <4BBD3365.90306@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nebojsa Trpkovic wrote:
> On 04/08/10 03:22, Eric Sandeen wrote:
>> How does it fail?
>>
>> Surely a bug.  :)  If you can provide details we'll look into it.
>> (perhaps it's obvious on first try but still worth saying exactly
>> what problematic behavior you saw, when reporting a bug you
>> encountered)
> 
> Well, I've done a simple test, described like:
> 
> "get the used sectors for a file
> hdparm --fibmap filename
> read a sector from the file eg. with
> sudo hdparm --read-sector 66385920 /dev/sda
> delete the file and sync
> rm filename;sync
> and read the sector a second time"

Ok, thanks, perfect test & explanation.

Well the good news is, at least it's nothing like discarding
the wrong block.  :)

Long explanation:

in ext4_free_blocks():

        /* 
         * We need to make sure we don't reuse the freed block until
         * after the transaction is committed, which we can do by
         * treating the block as metadata, below.  We make an
         * exception if the inode is to be written in writeback mode
         * since writeback mode has weak data consistency guarantees.
         */
        if (!ext4_should_writeback_data(inode))
                flags |= EXT4_FREE_BLOCKS_METADATA;


so here we don't set this flag for writeback mode.

Later in that function we do:

        if ((flags & EXT4_FREE_BLOCKS_METADATA) && ext4_handle_valid(handle)) {
...
		ext4_mb_free_metadata(handle, &e4b, new_entry);


ext4_mb_free_metadata adds to t_private_list:

        /* Add the extent to transaction's private list */
        spin_lock(&sbi->s_md_lock);
        list_add(&new_entry->list, &handle->h_transaction->t_private_list);
        spin_unlock(&sbi->s_md_lock);

Once we finally get to release_blocks_on_commit, only things on t_private_list
ultimately get discarded.

Anyway, at the root of this is right now the discard really only happens for
things flagged as metadata, which is a pretty funky thing to do.

(and indeed if you have a unique xattr block, you'll see it get discarded
even with data=writeback).

I'll have to think about the right way to do this... it seems pretty
convoluted to me right now.

-Eric
