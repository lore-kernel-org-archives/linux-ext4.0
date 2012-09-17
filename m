From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Mon, 17 Sep 2012 10:30:46 -0500
Message-ID: <50574226.3020908@redhat.com>
References: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com> <20120915183023.GA9895@thunk.org> <505739F8.9050305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab2IQPat (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 11:30:49 -0400
In-Reply-To: <505739F8.9050305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/17/12 9:55 AM, Eric Sandeen wrote:
> On 9/15/12 1:30 PM, Theodore Ts'o wrote:
>> On Mon, Sep 10, 2012 at 11:55:48AM -0000, Carlos Maiolino wrote:
>>> htree_dirblock_to_tree() declares a non-initialized 'err' variable,
>>> which is passed as a reference to another functions expecting them
>>> to set this variable with thei error codes.  It's passed to
>>> ext4_bread(), which then passes it to ext4_getblk(). If
>>> ext4_map_blocks() returns 0 due to a lookup failure, leaving the
>>> ext4_getblk() buffer_head uninitialized, it will make ext4_getblk()
>>> return to ext4_bread() without initialize the 'err' variable, and
>>> ext4_bread() will return to htree_dirblock_to_tree() with this
>>> variable still uninitialized.
>>
>> Hi Carlos,
>>
>> Thanks for noticing this problem!
>>
>> In the case where there is no block mapping for a particular block,
>> ext4_bread() can return NULL, and with your patch, *err will now be
>> zero instead of some uninitialized value.  That's an improvement, and
>> in the case of htree_dirblock_to_tree(), when we return 0 as an
>> "error", the caller will do the right thing.
> 
> Hm, sorry, I had counseled Carlos to do that.  I figured a bmap
> call w/o create set, returning a NULL bh was perfectly valid - it simply
> means that it's not mapped there, right? - so a 0 retval made sense
> to me.

fwiw, the uninit variable came about as part of
2ed886852adfcb070bf350e66a0da0d98b2f3ab5; before that we happily returned
0 for an unmapped block; see below.  So unless something else has changed
since then, Carlos' patch shouldn't be doing any harm, at least.  An
audit may be in order but anyone misunderstanding a NULL/0 return has probably
been that way for a while.

 struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
                                ext4_lblk_t block, int create, int *errp)
 {
        struct buffer_head dummy;
        int fatal = 0, err;
        int flags = 0;
 
        J_ASSERT(handle != NULL || create == 0);
 
        dummy.b_state = 0;
        dummy.b_blocknr = -1000;
        buffer_trace_init(&dummy.b_history);
        if (create)
                flags |= EXT4_GET_BLOCKS_CREATE;
        err = ext4_get_blocks(handle, inode, block, 1, &dummy, flags);
        /*
         * ext4_get_blocks() returns number of blocks mapped. 0 in
         * case of a HOLE.
         */
        if (err > 0) {
                if (err > 1)
                        WARN_ON(1);
                err = 0;
        }
        *errp = err;



