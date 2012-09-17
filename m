From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Mon, 17 Sep 2012 09:55:52 -0500
Message-ID: <505739F8.9050305@redhat.com>
References: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com> <20120915183023.GA9895@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502Ab2IQOzz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 10:55:55 -0400
In-Reply-To: <20120915183023.GA9895@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/15/12 1:30 PM, Theodore Ts'o wrote:
> On Mon, Sep 10, 2012 at 11:55:48AM -0000, Carlos Maiolino wrote:
>> htree_dirblock_to_tree() declares a non-initialized 'err' variable,
>> which is passed as a reference to another functions expecting them
>> to set this variable with thei error codes.  It's passed to
>> ext4_bread(), which then passes it to ext4_getblk(). If
>> ext4_map_blocks() returns 0 due to a lookup failure, leaving the
>> ext4_getblk() buffer_head uninitialized, it will make ext4_getblk()
>> return to ext4_bread() without initialize the 'err' variable, and
>> ext4_bread() will return to htree_dirblock_to_tree() with this
>> variable still uninitialized.
> 
> Hi Carlos,
> 
> Thanks for noticing this problem!
> 
> In the case where there is no block mapping for a particular block,
> ext4_bread() can return NULL, and with your patch, *err will now be
> zero instead of some uninitialized value.  That's an improvement, and
> in the case of htree_dirblock_to_tree(), when we return 0 as an
> "error", the caller will do the right thing.

Hm, sorry, I had counseled Carlos to do that.  I figured a bmap
call w/o create set, returning a NULL bh was perfectly valid - it simply
means that it's not mapped there, right? - so a 0 retval made sense
to me.

> But there are other places where when ext4_bread() returns NULL with
> err set to 0, the function ends up returning err, i.e., in ext4_add_entry:
> 
> 		bh = ext4_bread(handle, dir, block, 0, &retval);
> 		if(!bh)
> 			return retval;
> 
> ... which will cause the caller of ext4_add_entry() to think that the
> function had succeeded.
> 
> In the case of directories, there is never supposed to "holes" in
> directories, so the right thing to do is to check to see if err = 0
> and in that case to call ext4_error() to mark the file system as being
> inconsistent, and then returning some kind of error like -EIO.

Hm good point.  Yeah, callers need to understand what that means.

> So your patch is an improvement, but I'm worried that there were cases
> where we had been returning some uninitialized, non-zero stack
> garbage, we had been serendipously treating the case of a directory
> hole as an "error", now we we consider that situation as a "success"
> even though the calling function (such as ext4_add_entry) had not
> completed its processing.  Which is a very long-winded way of saying
> that we need to audit all of the functions which call ext4_bread() so
> that they do the right thing when ext4_bread() returns NULL and err is
> set to zero.

I agree with that.  :)

-Eric

> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

