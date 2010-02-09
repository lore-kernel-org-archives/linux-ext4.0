From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 09/11] ext4: subtree add kconfig options
Date: Mon, 8 Feb 2010 19:10:45 -0500
Message-ID: <87f94c371002081610u69b4367bocdb016b34ba907cd@mail.gmail.com>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-10-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:44795 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab0BIAKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2010 19:10:46 -0500
Received: by iwn12 with SMTP id 12so7911977iwn.26
        for <linux-ext4@vger.kernel.org>; Mon, 08 Feb 2010 16:10:45 -0800 (PST)
In-Reply-To: <1265635693-12182-10-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 8, 2010 at 8:28 AM, Dmitry Monakhov <dmonakhov@openvz.org> =
wrote:
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
> =A0fs/ext4/Kconfig =A0| =A0 =A09 +++++++++
> =A0fs/ext4/Makefile | =A0 =A01 +
> =A02 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index 9ed1bb1..6c05d1a 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -75,6 +75,15 @@ config EXT4_FS_SECURITY
> =A0 =A0 =A0 =A0 =A0If you are not using a security module that requir=
es using
> =A0 =A0 =A0 =A0 =A0extended attributes for file security labels, say =
N.
>
> +config EXT4_SUBTREE
> + =A0 =A0 =A0 bool "Ext4 subtree support"
> + =A0 =A0 =A0 depends on EXT4_FS_XATTR
> + =A0 =A0 =A0 default y
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 =A0 Enables subtree support for ext4 filesystem
> +
> + =A0 =A0 =A0 =A0 If you don't know what subtree are, say N
> +

Unless the subtree patch is enhanced to support orthogonal use cases,
the help text should explicitly comment on this limitation.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
