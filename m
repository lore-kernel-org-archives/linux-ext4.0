From: Will Newton <will.newton@gmail.com>
Subject: Re: [PATCH 5/6] Btrfs: fail if we try to use hole punch
Date: Tue, 9 Nov 2010 10:05:34 +0000
Message-ID: <AANLkTiksTsZqo1yUNVEJSiwE-7ccyWDv+wLvTZaoZOJ0@mail.gmail.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<1289248327-16308-5-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com,
	cluster-devel@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42341 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab0KIKFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Nov 2010 05:05:37 -0500
In-Reply-To: <1289248327-16308-5-git-send-email-josef@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 8, 2010 at 8:32 PM, Josef Bacik <josef@redhat.com> wrote:

Hi Josef,

> Btrfs doesn't have the ability to punch holes yet, so make sure we re=
turn
> EOPNOTSUPP if we try to use hole punching through fallocate. =A0This =
support can
> be added later. =A0Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> =A0fs/btrfs/inode.c | =A0 =A04 ++++
> =A01 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 78877d7..c590add 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6936,6 +6936,10 @@ static long btrfs_fallocate(struct inode *inod=
e, int mode,
> =A0 =A0 =A0 =A0alloc_start =3D offset & ~mask;
> =A0 =A0 =A0 =A0alloc_end =3D =A0(offset + len + mask) & ~mask;
>
> + =A0 =A0 =A0 /* We only support the FALLOC_FL_KEEP_SIZE mode */
> + =A0 =A0 =A0 if (mode && (mode & FALLOC_FL_KEEP_SIZE))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
> +

This test looks rather odd. Why do we need to test that mode is
non-zero AND that mode has a specific bit set? Is there a missing !
here?
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
