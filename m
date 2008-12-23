From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Problems with the max value for create directory
Date: Tue, 23 Dec 2008 15:12:47 -0500
Message-ID: <20081223201247.GU23723@mit.edu>
References: <495054DE.9030405@cn.fujitsu.com> <495062D1.6010805@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51348 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbYLWUM6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Dec 2008 15:12:58 -0500
Content-Disposition: inline
In-Reply-To: <495062D1.6010805@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 23, 2008 at 01:02:25PM +0900, Toshiyuki Okajima wrote:
>> I creat 65537 long directories and failed when the block size is 102=
4.
>>
>
> static int ext4_mkdir(struct inode *dir, struct dentry *dentry, int m=
ode)
> {
>          handle_t *handle;
>          struct inode *inode;
>          struct buffer_head *dir_block;
>          struct ext4_dir_entry_2 *de;
>          int err, retries =3D 0;
>
>          if (EXT4_DIR_LINK_MAX(dir))
> =E3=80=80=E3=80=80=E3=80=80=E3=80=80=E3=80=80^^^^^^^^^^^^^^^^^^^^^^^^=
^^^=E3=80=80=E3=80=80=E3=80=80=E3=80=80
>                  return -EMLINK;
>
> This limit is ext4's specification.

The definition of EXT4_DIR_LINK_MAX is here:

#define is_dx(dir) (EXT4_HAS_COMPAT_FEATURE(dir->i_sb, \
				      EXT4_FEATURE_COMPAT_DIR_INDEX) && \
		      (EXT4_I(dir)->i_flags & EXT4_INDEX_FL))
#define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >=3D EXT4=
_LINK_MAX)

So that's not it.  The problem is that indexed diretories have a limit
that only allows the trees to be two levels deep.  The fanout is
normally big enough that this is effectively not a problem, but if you
use very long filenames, and a 1k blocksize, you will run into this
limit much more quickly.  So the problem is not the number of sub
directories, but the maximum depth of the htree allowed in Daniel
Phillips' relatively restricted implementation.  Note that with a 4k
block filesystem, the limits get expanded by a factor of 4 cubed, or
64.  And most of the time users aren't maximal length named directory
entries, which further pushes the limit out in the normal case.

It in theory would be possible to relax this restriction, using a more
advanced htree implementation and a feature flag to allow backwards
compatibility with older kernels that only support the maximal depth.
Andreas has a prototype kernel implementation which in theory could be
added to ext4.  It hasn't been high on my priority list to complete,
but if someone else really finds this limit to be annoying, it is a
project they might try to complete.

Were you writing this test program because this is a realistic
situation for your application, or just to explore the limits of ext4?

Regards,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
