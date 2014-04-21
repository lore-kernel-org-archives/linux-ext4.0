From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH v2 2/2] ext4: disable COLLAPSE_RANGE for bigalloc
Date: Mon, 21 Apr 2014 13:52:28 +0900
Message-ID: <001101cf5d1d$7f6bce00$7e436a00$@samsung.com>
References: <000d01cf5b8b$5b149110$113db330$@samsung.com>
 <20140419221221.GD13492@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:10056 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaDUEwb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2014 00:52:31 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4D00EMV6VHGL40@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Mon, 21 Apr 2014 13:52:29 +0900 (KST)
In-reply-to: <20140419221221.GD13492@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Sat, Apr 19, 2014 at 01:53:50PM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > Once COLLAPSE RANGE is be disable for ext4 with bigalloc feature till finding
> > root-cause of problem. It will be enable with fixing that regression of
> > xfstest(generic 075 and 091) again.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> 
> Thanks, applied.
> 
> What's the status of the "[2/3] ext4: fix ZERO_RANGE test failure in
> data journalling mode" patch.  Is it no longer needed?
It is needed. Currently, I am considering your suggestion of introducing
EXT4_I(inode)->i_write_mutex which can also include ext4_aio_mutex.

Thanks!
> 
>      		       	       	     - Ted

