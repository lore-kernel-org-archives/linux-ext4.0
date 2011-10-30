From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 3/3] ext4: let ext4_discard_partial_buffers handle
 unaligned range correctly
Date: Sun, 30 Oct 2011 21:36:13 +0800
Message-ID: <CAGBYx2a7Hzrpq00qMz1Hd1UrMEk=7p6_2q7U-SrRC7eBLMb0Ng@mail.gmail.com>
References: <1319974203-2625-1-git-send-email-xiaoqiangnk@gmail.com>
	<1319974203-2625-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40630 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1J3NgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 09:36:13 -0400
Received: by ywf7 with SMTP id 7so213989ywf.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Oct 2011 06:36:13 -0700 (PDT)
In-Reply-To: <1319974203-2625-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46orgot to say that the bug was found by running xfstests 91.

Thx!

Yongqiang.

On Sun, Oct 30, 2011 at 7:30 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> As comment says, we should handle unaligned range rather than aligned
> one.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> =A0fs/ext4/inode.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e113de8..f97d671 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3209,8 +3209,8 @@ int ext4_discard_partial_page_buffers_no_lock(h=
andle_t *handle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * to be updated with the contents of =
the block before
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * we write the zeros on top of it.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(from & (blocksize - 1)) ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !((from + length) & (blocksize =
- 1))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((from & (blocksize - 1)) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((from + length) & (blocksize -=
 1))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0create_empty_buffers(p=
age, blocksize, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> --
> 1.7.5.1
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
