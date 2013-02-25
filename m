From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 5/5] ext4: invalidate exntent-status-tree during
 extent_migration
Date: Tue, 26 Feb 2013 01:04:50 +0800
Message-ID: <20130225170450.GA4616@gmail.com>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
 <1361808463-25471-5-git-send-email-dmonakhov@openvz.org>
 <87d2vowe4l.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:54728 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3BYQt5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Feb 2013 11:49:57 -0500
Received: by mail-da0-f49.google.com with SMTP id t11so609959daj.22
        for <linux-ext4@vger.kernel.org>; Mon, 25 Feb 2013 08:49:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87d2vowe4l.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmitry,

Thank you very much for fixing this regression.  A very quick test is
run in my desktop and xfstests #300 and #301 can pass.  Feel free to
add:
Reviewed-and-tested-by: Zheng Liu <wenqing.lz@taobao.com>

I will add self-testing infrastructure in status tree ASAP and re-run
xfstests.

Thanks!!
                                                - Zheng

On Mon, Feb 25, 2013 at 08:29:46PM +0400, Dmitry Monakhov wrote:
> On Mon, 25 Feb 2013 20:07:43 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> > mext_replace_branches() will change inode's extents layout so
> > we have to drop corresponding cache.
> > 
> > TESTCASE:  301'th xfstest was not yet accepted to official xfstest's branch
> > and can be found here: https://github.com/dmonakhov/xfstests/commit/7b7efeee30a41109201e2040034e71db9b66ddc0
> One BIG note about this patch.
> It fix BUG_ON(bh->b_blocknr != pblock) in fs/ext4/inode.c:1452
> but 300'th xfstest(from my repo) still failed due to data corruption in
> verifier thread. 
> LOG:
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/vzvg-scratch_dev
> /mnt_scratch
> 
> 300 33s ... [failed, exit status 1] - output mismatch (see 300.out.bad)
>     --- 300.out      2013-02-20 12:46:24.000000000 +0400
>     +++ 300.out.bad  2013-02-25 20:18:24.000000000 +0400
>     @@ -2,3 +2,5 @@
>      
>       Start defragment activity 
>      
>     +failed: '/usr/local/bin/fio /tmp/1665-300.fio'
>     +(see 300.full for details)
>      ...
>      (Run 'diff -u 300.out 300.out.bad' to see the entire diff)
> 
> #300.full
> crc32c: verify failed at file /mnt_scratch/test2 offset 16973824, length
>     65536
>        Expected CRC: d062565e
>        Received CRC: f2cd2028
>        received data dumped as test2.16973824.received
>        expected data dumped as test2.16973824.expected
> defrag-4k: Laying out IO file(s) (1 file(s) / 3400MB)
> donor-file-fuzzer: Laying out IO file(s) (1 file(s) / 3400MB)
> 
> #DIFF:
> --- /tmp/test2.16973824.expected        2013-02-25 20:23:04.000000000
>     +0400
> +++ /tmp/test2.16973824.received        2013-02-25 20:22:55.000000000
>     +0400
> @@ -254,3844 +254,6 @@
>  0000fd0 eb95 6201 89ec 151a bd72 9675 203c 0d80
>  0000fe0 b7ae b415 b8cc 0b2f b6f5 baab 9d0e 1741
>  0000ff0 f6de fbda d64b 1bd3 5edb 040c 7cdc 18e6
> -0001000 0bdb 5114 cd95 01eb 017b a435 d128 11af
> -0001010 202f 93c9 a80a 013e a405 c261 8b1c 0dab
> -0001020 b480 c649 1032 1b0a 3690 7e89 dee1 0ac7
> -0001030 26d2 9489 3c97 0bd8 24da 5f28 3d4e 066d
> -0001040 049b b978 7815 159c 8093 b4e1 b246 1c25
> .....
> -000ffc0 bbb1 fa68 5622 022d 9776 0174 2d90 1ecb
> -000ffd0 92ee b473 64f7 0bcb 725d 2d17 9265 0fff
> -000ffe0 6e4b ec74 5bc0 0618 0dc9 e669 953d 002f
> -000fff0 a1b9 35e8 ff73 17a5 9437 15e0 24fa 150a
> +0001000 0000 0000 0000 0000 0000 0000 0000 0000
> +*
>  0010000
> 
> It seems that we data was written to uninitialized extent, but
> unwritten->initialized extent conversion was missed somewhere.
> I have not fix for that issue yet.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/ext4/move_extent.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> > index d78c33e..c1f15b2 100644
> > --- a/fs/ext4/move_extent.c
> > +++ b/fs/ext4/move_extent.c
> > @@ -666,6 +666,14 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
> >  	int replaced_count = 0;
> >  	int dext_alen;
> >  
> > +	*err = ext4_es_remove_extent(orig_inode, from, count);
> > +	if (*err)
> > +		goto out;
> > +
> > +	*err = ext4_es_remove_extent(donor_inode, from, count);
> > +	if (*err)
> > +		goto out;
> > +
> >  	/* Get the original extent for the block "orig_off" */
> >  	*err = get_ext_path(orig_inode, orig_off, &orig_path);
> >  	if (*err)
> > -- 
> > 1.7.1
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
