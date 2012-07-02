From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4_fallocate
Date: Mon, 2 Jul 2012 11:03:11 +0800
Message-ID: <20120702030310.GA2406@gmail.com>
References: <20120625191744.GB9688@thunk.org>
 <4FE9B57F.4030704@redhat.com>
 <4FE9F9F4.7010804@zoho.com>
 <4FEA0DD1.8080403@gmail.com>
 <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
 <4FEC3FAA.1060503@redhat.com>
 <27810AD9-FEA3-4C82-A5EC-A4B9B5F90071@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	linux-ext4@vger.kernel.org, wenqing.lz@taobao.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46243 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab2GBCyz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 22:54:55 -0400
Received: by pbbrp8 with SMTP id rp8so6933280pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 19:54:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <27810AD9-FEA3-4C82-A5EC-A4B9B5F90071@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 29, 2012 at 01:02:35PM -0600, Andreas Dilger wrote:
> There is already code for this in the ext4 uninit extent handling.
> Currently the limit is 15(?) blocks, to inflate the write size up
> to zero-fill a 64kB chunk on 4kB blocksize filesystems.  I wouldn't
> object to increasing this to zero out a full 1MB (aligned) chunk
> under random IO cases.

I agree with you that we can increase it to 1MB chunk, and I will run
some tests to see the result.  In addition, I am thinking whether we can
provide a parameter in sysfs or some other places to adjust this value
dynamically.

Regards,
Zheng
