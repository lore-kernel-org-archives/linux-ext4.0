From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/3] Ext2: remove the overhead check about sb in the
 function ext2_new_blocks
Date: Wed, 6 Feb 2013 14:56:46 +0800
Message-ID: <20130206065645.GA32665@gmail.com>
References: <5112BB97.8040206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36436 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3BFGm0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2013 01:42:26 -0500
Received: by mail-pa0-f52.google.com with SMTP id fb1so608748pad.11
        for <linux-ext4@vger.kernel.org>; Tue, 05 Feb 2013 22:42:25 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <5112BB97.8040206@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 06, 2013 at 12:22:47PM -0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>=20
> It can be guranteed that inode->i_sb should not be null in vfs.
> So here the check about it is overhead.
>=20
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>=20
> sorry about wrong format patch=EF=BC=8C i will resend it later.

Hi Shilong,

If you want to re-send a patch series, add [RESEND] in subject, please.
Because it could make us know which is the latest one. :-)

Regards,
                                                - Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
