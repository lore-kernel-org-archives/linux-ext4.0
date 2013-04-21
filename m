From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 3/3] ext4: mark metadata blocks using bh flags
Date: Sun, 21 Apr 2013 08:09:14 +0200
Message-ID: <5173828A.2030809@suse.cz>
References: <20130421000522.GA5054@thunk.org> <1366502828-7793-1-git-send-email-tytso@mit.edu> <1366502828-7793-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-mm@kvack.org,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	mgorman@suse.de
To: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44265 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3DUGJS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Apr 2013 02:09:18 -0400
In-Reply-To: <1366502828-7793-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/21/2013 02:07 AM, Theodore Ts'o wrote:
> This allows metadata writebacks which are issued via block device
> writeback to be sent with the current write request flags.

Hi, where do these come from?
fs/ext4/ext4_jbd2.c: In function =E2=80=98__ext4_handle_dirty_metadata=E2=
=80=99:
fs/ext4/ext4_jbd2.c:218:2: error: implicit declaration of function
=E2=80=98mark_buffer_meta=E2=80=99 [-Werror=3Dimplicit-function-declara=
tion]
fs/ext4/ext4_jbd2.c:219:2: error: implicit declaration of function
=E2=80=98mark_buffer_prio=E2=80=99 [-Werror=3Dimplicit-function-declara=
tion]
cc1: some warnings being treated as errors

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4_jbd2.c | 2 ++
>  fs/ext4/inode.c     | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 0e1dc9e..fd97b81 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -215,6 +215,8 @@ int __ext4_handle_dirty_metadata(const char *wher=
e, unsigned int line,
> =20
>  	might_sleep();
> =20
> +	mark_buffer_meta(bh);
> +	mark_buffer_prio(bh);
>  	if (ext4_handle_valid(handle)) {
>  		err =3D jbd2_journal_dirty_metadata(handle, bh);
>  		if (err) {
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 62492e9..d7518e2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1080,10 +1080,14 @@ retry_journal:
>  /* For write_end() in data=3Djournal mode */
>  static int write_end_fn(handle_t *handle, struct buffer_head *bh)
>  {
> +	int ret;
>  	if (!buffer_mapped(bh) || buffer_freed(bh))
>  		return 0;
>  	set_buffer_uptodate(bh);
> -	return ext4_handle_dirty_metadata(handle, NULL, bh);
> +	ret =3D ext4_handle_dirty_metadata(handle, NULL, bh);
> +	clear_buffer_meta(bh);
> +	clear_buffer_prio(bh);
> +	return ret;
>  }
> =20
>  /*
>=20


--=20
js
suse labs
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
