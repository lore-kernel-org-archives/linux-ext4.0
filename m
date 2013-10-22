From: Tao Ma <tm@tao.ma>
Subject: Re: fix the ext4_read_inline_dir return value
Date: Tue, 22 Oct 2013 10:10:27 +0800
Message-ID: <5265DE93.8060406@tao.ma>
References: <CAAFszuV7tXpGA5GVWtLzzHZayPgN-M+n_W4LN67i=ueicfZb+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"lewis.liulei" <lewis.liulei@huawei.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Robin Dong <sanbai@taobao.com>
To: Boxi Liu <boxi10liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from server.coly.li ([162.144.45.48]:57410 "EHLO server.coly.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab3JVCKd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Oct 2013 22:10:33 -0400
In-Reply-To: <CAAFszuV7tXpGA5GVWtLzzHZayPgN-M+n_W4LN67i=ueicfZb+Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Boxi,
On 10/22/2013 12:33 AM, Boxi Liu wrote:
> hi=A3=AC
> there may be a bug in ext4_read_inline_dir() function with inline_dat=
a feature.
> when I recursion call a sys_old_readdir to read a direntry's
> sub_dentry,I find that the ext4_read_inline_dir return the len of the
> inline_data ,but in the no inline_data case,it will return 0.It is
> inconsistent.
> So I try to make a patch to fix it.
The fix looks good to me an you can add
Acked-by: Tao Ma <boyu.mt@taobao.com>

But next time please generate the patch with git format-patch and send
it using git send-email.

Thanks,
Tao
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
