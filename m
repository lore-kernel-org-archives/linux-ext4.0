From: =?UTF-8?B?IlBldGVyIFBhbijmvZjljavlubMpIg==?=
	<panweiping3@gmail.com>
Subject: Re: [PATCH] ext4:memset is needless in ext4_ext_remove_space()
Date: Mon, 08 Nov 2010 14:24:06 +0800
Message-ID: <4CD79786.9000303@gmail.com>
References: <4CD75033.7080902@redflag-linux.com> <20101108043752.GB5563@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Dan Carpenter <error27@gmail.com>,
	=?UTF-8?B?Iua9mOWNq+W5syhQZXRlciBQ?= =?UTF-8?B?YW4pIg==?=
	<wppan@redflag-linux.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kerne
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37649 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0KHGZy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Nov 2010 01:25:54 -0500
In-Reply-To: <20101108043752.GB5563@bicker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010=E5=B9=B411=E6=9C=8808=E6=97=A5 12:37, Dan Carpenter wrote:
> This is inside a loop and sometimes we do i++ and sometimes i--. Are
> you absolutely positive that path + i isn't initialized?
>
> I haven't followed this code through all the way but my instinct is
> that the memset is there for a reason.
>   =20
I know that I misunderstood it.

Thank you!

Regards

Peter Pan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
