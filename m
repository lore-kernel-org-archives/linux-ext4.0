From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 1/2] mke2fs: fix force option to create filesystem on
 mounted device
Date: Tue, 07 May 2013 17:14:14 +0900
Message-ID: <5188B7D6.8010200@sx.jp.nec.com>
References: <510F6B75.6090408@sx.jp.nec.com> <5179C331.7050109@sx.jp.nec.com> <4A2A7340-F533-4C6E-B05C-39EC548A3D5F@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:40727 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3EGIXS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 May 2013 04:23:18 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r478NElh027536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 7 May 2013 17:23:14 +0900 (JST)
In-Reply-To: <4A2A7340-F533-4C6E-B05C-39EC548A3D5F@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2013/04/27 6:45, Andreas Dilger wrote:
>> http://patchwork.ozlabs.org/patch/217838/
>
> Out of curiosity, is formatting a mounted filesystem something
> that you are actually trying to do, or is this just a case of
> trying to make the mke2fs usage consistent with the man page?

The purpose of this patch is the latter.

>> http://patchwork.ozlabs.org/patch/217839/
>
> I don't understand the second patch.  If the user tries to format
> the /dev/loop device, then it is a "block device" and not really
> a "regular file" (i.e. the user probably knows what is going on).
> I don't think it is necessary to include the extra code and checking
> in this case.  Do I misunderstand what your patch is doing?

/dev/loop device is a block device as you know, but an image file is
a regular file and you can format it.
I think we have to prevent mke2fs to in-use image file by mistake.

Regards,
Kazuya Mio
