From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after transaction restart
Date: Wed, 26 May 2010 12:53:45 +0400
Message-ID: <87ljb7qc12.fsf@openvz.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
	<20100525133241.GF5556@thunk.org> <87632ckqcy.fsf@openvz.org>
	<20100525213817.GO5556@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com, tytso@mit.ed
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57947 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933793Ab0EZIxt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 May 2010 04:53:49 -0400
Received: by fxm5 with SMTP id 5so4122139fxm.19
        for <linux-ext4@vger.kernel.org>; Wed, 26 May 2010 01:53:47 -0700 (PDT)
In-Reply-To: <20100525213817.GO5556@thunk.org> (tytso@mit.edu's message of
	"Tue, 25 May 2010 17:38:17 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Tue, May 25, 2010 at 06:28:29PM +0400, Dmitry Monakhov wrote:
>> tytso@mit.edu writes:
>> 
>> > On Thu, Apr 22, 2010 at 08:31:11AM +0400, Dmitry Monakhov wrote:
>> >> @@ -2480,6 +2480,11 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
>> >>  out:
>> >>  	ext4_ext_drop_refs(path);
>> >>  	kfree(path);
>> >> +	if (err == EAGAIN) {
>> >
>> > Surely this should be "err == -EAGAIN", no?  I'm curious how this
>> > patch worked for with this typo....
>> As usually it fix one thing, and broke another :(.
>> So in case of alloc/truncate restart truncate will be aborted,
>> so i_size != i_disk_size which must be caught by fsck (my test run
>> it every time) but this never happens which is very strange.
>> The only reason i can explain this that truncate was called second
>> time which is probable due to should_retry_alloc logic.
>
> Does adding the optimization I suggested help?  I was nervous because
> we don't immediately abort the loop after the rm_leaf function returns
> -EAGAIN.
Sorry, but seems i don't get your idea.
we have following code:
2394: while (i >= 0 && err == 0) {
                if (i == depth) {
                        /* this is leaf block */
                        err = ext4_ext_rm_leaf(handle, inode, path,
                        start);
                        /* root level has p_bh == NULL, brelse() eats this */
                        brelse(path[i].p_bh);
                        path[i].p_bh = NULL;
                        i--;
                        continue;
                       ^^^^^^^^^^^^^^^^^
<<< So if rm_leaf has failed we will quit from while loop
                }

>And disentangling the code to free the buffer references
> from the other processing that was happening was difficult, and I was
> worried about other potential side effects when the code tried to
> modify blocks that were already added to the transaction.
>
>        	      	   		      	     - Ted
