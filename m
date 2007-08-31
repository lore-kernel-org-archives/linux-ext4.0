From: FNST-Wang Chen <wangchen@cn.fujitsu.com>
Subject: Re: [PATCH] ext3: Fix not initialized hash info in ext3_dx_find_entry()
Date: Fri, 31 Aug 2007 09:34:39 +0800
Message-ID: <46D7702F.6000607@cn.fujitsu.com>
References: <00ee01c7eb14$051e3ed0$0201a8c0@pinkpig> <20070830152949.GE10160@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Wang Chen <ellre923@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:58193 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXHaBet (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2007 21:34:49 -0400
In-Reply-To: <20070830152949.GE10160@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Agree, thanks.

Theodore Tso said the following on 2007-8-30 23:29:
> On Thu, Aug 30, 2007 at 10:42:33PM +0800, Wang Chen wrote:
>  =20
>> +               if (dentry){
>> +                       ext3fs_dirhash(dentry->d_name.name,=20
>> dentry->d_name.len,
>> +                                      &hinfo);
>> +               } else {
>> +                       return NULL;
>> +               }
>>    =20
>
> It's really not necessary to call ext3fs_dirhash(), since we don't
> need the hash value for the '.' and '..' case.  So here's a better
> patch....
>
>      	      	    	    	- Ted
>
> >From c2ff518e6f529f1d8b627f0e8be5d6f8af32747f Mon Sep 17 00:00:00 20=
01
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Thu, 30 Aug 2007 11:26:24 -0400
> Subject: [PATCH] ext3: Fix use of uninitialized variable in ext3_dx_f=
ind_entry()
>
> In the case where we are looking up '.' and '..', those files are
> always in the first directory block, so we don't need worry about the
> hash value.  This avoids a lint warning message, as a minor cleanup.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext3/namei.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 1586807..c278fc7 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -932,7 +932,7 @@ static struct buffer_head * ext3_dx_find_entry(st=
ruct dentry *dentry,
>  {
>  	struct super_block * sb;
>  	struct dx_hash_info	hinfo;
> -	u32 hash;
> +	u32 hash =3D 0;
>  	struct dx_frame frames[2], *frame;
>  	struct ext3_dir_entry_2 *de, *top;
>  	struct buffer_head *bh;
> @@ -947,13 +947,13 @@ static struct buffer_head * ext3_dx_find_entry(=
struct dentry *dentry,
>  	if (namelen > 2 || name[0] !=3D '.'||(name[1] !=3D '.' && name[1] !=
=3D '\0')){
>  		if (!(frame =3D dx_probe(dentry, NULL, &hinfo, frames, err)))
>  			return NULL;
> +		hash =3D hinfo.hash;
>  	} else {
>  		frame =3D frames;
>  		frame->bh =3D NULL;			/* for dx_release() */
>  		frame->at =3D (struct dx_entry *)frames;	/* hack for zero entry*/
>  		dx_set_block(frame->at, 0);		/* dx_root block is 0 */
>  	}
> -	hash =3D hinfo.hash;
>  	do {
>  		block =3D dx_get_block(frame->at);
>  		if (!(bh =3D ext3_bread (NULL,dir, block, 0, err)))
>  =20


--=20
Best Regards,
A new email address of FJWAN is launched from Apr.1 2007.
The updated address is: wangchen@cn.fujitsu.com
--------------------------------------------------
Wang Chen
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
8/F., Civil Defense Building, No.189 Guangzhou Road,
Nanjing, 210029, China
TEL=EF=BC=9A+86+25-86630566-850
=46UJITSU INTERNAL=EF=BC=9A79955-850
=46AX=EF=BC=9A+86+25-83317685
MAIL=EF=BC=9Awangchen@cn.fujitsu.com
--------------------------------------------------
