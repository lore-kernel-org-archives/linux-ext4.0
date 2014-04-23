From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH] ext4: use EINVAL if not a regular file in ext4_fallocate()
Date: Wed, 23 Apr 2014 17:35:35 +0900
Message-ID: <004b01cf5ece$ff6fe1b0$fe4fa510$@samsung.com>
References: <000e01cf5b8d$c57e9f80$507bde80$@samsung.com>
 <20140423060823.GA9262@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
To: 'Zheng Liu' <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63115 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaDWIfw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2014 04:35:52 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4H00KJ06JC8CA0@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 23 Apr 2014 17:35:36 +0900 (KST)
In-reply-to: <20140423060823.GA9262@gmail.com>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Sat, Apr 19, 2014 at 02:11:07PM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > Punch hole return EOPNOTSUPP about a non-REGULAR file also. So change EINVAL
> > to be consistent with xfs. And move this check to the start of
> > ext4_fallocate().
> 
> IMHO, EOPNOTSUPP makes sense to me.  From the man page of fallocate(2):
Hi Zheng.
IMHO, EOPNOTSUPP should be used where the operation is not yet implemented but
there is some chance that it could be implemented in future.
for example, it is ok for FS which has not yet implemented punch hole to
return EOPNOTSUPP as they could implement it in future. but for the cases where
it does not make sense to implement the operation, for example punching hole
for non regular files does not make any sense, it is better to use EINVAL.
On these lines, I agree that returning EOPNOTSUPP for collapse range in case of
non-extent based file is ok, as it is plausible to implemet collapse range for
non extent files in future.

Thanks for your opinion!
> 
> EOPNOTSUPP
>       The filesystem containing the file referred to by fd does not
>       support this operation; or the mode is not supported by the
>       filesystem containing the file referred to by fd.
> 
> Regards,
>                                                 - Zheng


