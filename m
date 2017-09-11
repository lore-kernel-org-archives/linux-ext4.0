From: Jaco Kroon <jaco@uls.co.za>
Subject: Re: [PATCH] e2fsck: add optimization for heavily hard-linked file
 systems
Date: Mon, 11 Sep 2017 12:19:05 +0200
Message-ID: <b7d3ae07-a822-cd7a-ee89-65d67557c234@uls.co.za>
References: <20170819011635.1815929-1-dsp@fb.com>
 <20170822022948.nyn6fessudjaj5xh@thunk.org>
 <a4b31ace-3a54-051d-75df-b47452c789cb@uls.co.za>
 <20170822124505.xr7wnxonsbml3mgh@thunk.org>
 <00f408c1-215e-39e2-dec4-8f05eb604f97@uls.co.za>
 <20170823232351.643l4wg7pvnnxyts@thunk.org>
 <48660f5d-2e53-f0ff-e0e5-169a1d2d631f@uls.co.za>
 <20170826153313.le7biqxzg7mz6f32@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Doug Porter <dsp@fb.com>, linux-ext4@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from othala.uls.co.za ([154.73.34.12]:60130 "EHLO othala.uls.co.za"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750984AbdIKKT0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Sep 2017 06:19:26 -0400
In-Reply-To: <20170826153313.le7biqxzg7mz6f32@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

I got severely side-tracked after the previous look at this.

With the mentions below, ACK.

Kind Regards,
Jaco


On 26/08/2017 17:33, Theodore Ts'o wrote:
> On Thu, Aug 24, 2017 at 11:08:52AM +0200, Jaco Kroon wrote:
>>> +#define E2F_OPT_ICOUNT_FULLMAP	0x20000 /* don't optimize extents */
>> description here seems wrong?  Perhaps "use fullmap for inode link count" ?
> Oops, fixed.
>
>>> --- a/e2fsck/pass1.c
>>> +++ b/e2fsck/pass1.c
>>> @@ -711,6 +711,7 @@ extern errcode_t e2fsck_setup_icount(e2fsck_t ctx, const char *icount_name,
>>>    	errcode_t		retval;
>>>    	char			*tdb_dir;
>>>    	int			enable;
>>> +	int			full_map;
>>>    	*ret = 0;
>>> @@ -734,6 +735,8 @@ extern errcode_t e2fsck_setup_icount(e2fsck_t ctx, const char *icount_name,
>>>    	}
>>>    	e2fsck_set_bitmap_type(ctx->fs, EXT2FS_BMAP64_RBTREE, icount_name,
>>>    			       &save_type);
>>> +	if (ctx->options & E2F_OPT_ICOUNT_FULLMAP)
>>> +		flags |= EXT2_ICOUNT_OPT_FULLMAP;
>>>    	retval = ext2fs_create_icount2(ctx->fs, flags, 0, hint, ret);
>>>    	ctx->fs->default_bitmap_type = save_type;
>>>    	return retval;
>> This isn't used for pass1 (I did originally use full_map either way then
>> decided to only use it for pass2) - and we to receive flags coming into this
>> function - shouldn't this perhaps rather go into pass2.c (e2fsck_pass2
>> function to be more specific)?  This really is cosmetic imho.
> The e2fsck_setup_icount() function is used for both pass1 and pass2.
>
>>> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
>>> index ff961483b..939862f1a 100644
>>> --- a/e2fsck/unix.c
>>> +++ b/e2fsck/unix.c
>>> @@ -709,9 +709,18 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
>>>    		} else if (strcmp(token, "nodiscard") == 0) {
>>>    			ctx->options &= ~E2F_OPT_DISCARD;
>>>    			continue;
>>> +		} else if (strcmp(token, "optimize_extents") == 0) {
>>> +			ctx->options &= ~E2F_OPT_NOOPT_EXTENTS;
>>> +			continue;
>> unrelated, but makes sense :).
> Yes, this was a cleanup I was doing as I weant.
>
>>> +		if (!retval) {
>>> +			memset(icount->fullmap, 0,
>>> +			*sizeof(__u32)*  * fs->super->s_inodes_count); <-------
>> this of course should be sizeof(__u16), or sizeof(*count->fullmap) which
>> will track the type pointed to.  It might be better practice to store
>> "sizeof(*icount->fullmap) * fs->super->s_inodes_count" to a variable and
>> just re-use it.
> Good point.  Fixed.
>
>>>    		goto errout;
>>> +
>> Extra line can be removed.
>>>    	if (flags & EXT2_ICOUNT_OPT_INCREMENT) {
> Removed.
>
> Thanks for taking a look at the patch!
>
> 						- Ted
