From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 04/12] ext4: Disable merging of uninitialized extents
Date: Thu, 31 Jan 2013 18:09:15 +0400
Message-ID: <8738xhsaus.fsf@openvz.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz> <1358510446-19174-5-git-send-email-jack@suse.cz> <87vcamdi6e.fsf@openvz.org> <87a9rpssj8.fsf@openvz.org> <20130131123930.GA4612@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:62822 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3AaOJV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2013 09:09:21 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so1966111lab.9
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2013 06:09:19 -0800 (PST)
In-Reply-To: <20130131123930.GA4612@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 31 Jan 2013 13:39:30 +0100, Jan Kara <jack@suse.cz> wrote:
> On Thu 31-01-13 11:47:23, Dmitry Monakhov wrote:
> > On Thu, 24 Jan 2013 13:49:45 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> > > On Fri, 18 Jan 2013 13:00:38 +0100, Jan Kara <jack@suse.cz> wrote:
> > > > Merging of uninitialized extents creates all sorts of interesting race
> > > > possibilities when writeback / DIO races with fallocate. Thus
> > > > ext4_convert_unwritten_extents_endio() has to deal with a case where
> > > > extent to be converted needs to be split out first. That isn't nice
> > > > for two reasons:
> > > > 
> > > > 1) It may need allocation of extent tree block so ENOSPC is possible.
> > > > 2) It complicates end_io handling code
> > > As we already discussed your idea is 100% correct, but even with
> > > what patch I still able to trigger situation where split it required.
> > > I've got following error with this patch applied on top of 7f5118629f7
> > > EXT4-fs error (device dm-3): ext4_convert_unwritten_extents_endio:3411:
> > > inode #12: comm kworker/u:4: Written extent modified before IO finished:
> > > extent logical block 1379787, len 64; IO logical block 1379787, len 21
> > > 
> > > ------------[ cut here ]------------
> > > WARNING: at fs/ext4/extents.c:4518
> > > ext4_convert_unwritten_extents+0x149/0x210 [ext4]()
> > OK I've found it. I'm a bit disappointed, it is even not a race
> > condition, but simple corruption.
> > Patch is available here: http://article.gmane.org/gmane.comp.file-systems.ext4/36762
> > link for sain mailer client: <1359617098-18451-1-git-send-email-dmonakhov@openvz.org>
> > After this bug was fixed it is safe to apply both Jan's patches:
> > [PATCH 04/12] ext4: Disable merging of uninitialized extents
> > [PATCH 05/12] ext4: Remove unnecessary wait for extent conversion in ext4_fallocate()
> > At least it survives after all my tests.
>   Thanks for debugging this. I was looking into the code but it didn't come
> to my mind what happens when ext4_ext_split() fails.
ext4_ext_split does have not fail.
EXTENT:a----------b-------------c------d
It call ext4_ext_split_at twice:
first ext4_ext_split_at() should split [a,d] to [a,c],[c,d]
second ext4_ext_split_at() should split [a,c] to [a,b],[b,c]

But if first ext4_ext_split_at() internally failed due to ENOSPC it will
does ext_ext_zeroout() which is correct(if ).
Second one expect to operate on [a,c] which should be uninitialized,
but it operate on [a,d] which was initialized. At the end it mark
extent as uninitialized here:
        if (split == ee_block) {
                /*                                                                                                                               
                 * case b: block @split is the block that the extent
                 begins with                                                                 
                 * then we just change the state of the extent, and
                 splitting                                                                    
                 * is not needed.                                                                                                                
                 */
                if (split_flag & EXT4_EXT_MARK_UNINIT2)
                        ext4_ext_mark_uninitialized(ex);
####^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                else
                        ext4_ext_mark_initialized(ex);
...

In fact my first ext4_ext_split_at() result in zeroout we can skip
second one because it is not necessary, but I just clear
EXT4_EXT_MARK_UNINIT2 flag if extent becomes initialized.
And fairly to say my patch is not quite right because it is not
not correct to perform zeroout on initialized extent.
I'll send updated version in a minute.

>  
> > BTW: It is appeared that ext4_debug() infrastructure is almost unusable
> > because based on printk() instead of light-wait event tracing infrastructure.
> > I'm now work on patch-set which fix that.
>   That would be certainly welcome. ext4_debug() infrastructure comes from
> times when tracing didn't exist so we used what we could. These days it's
> cumbersome...
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
