From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4_fallocate
Date: Mon, 2 Jul 2012 11:16:11 +0800
Message-ID: <20120702031611.GB2406@gmail.com>
References: <4FE8086F.4070506@zoho.com>
 <20120625085159.GA18931@gmail.com>
 <20120625191744.GB9688@thunk.org>
 <4FE9B57F.4030704@redhat.com>
 <4FE9F9F4.7010804@zoho.com>
 <4FEA0DD1.8080403@gmail.com>
 <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33305 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab2GBDHz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2012 23:07:55 -0400
Received: by dady13 with SMTP id y13so6792048dad.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Jul 2012 20:07:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FEB9115.6090309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 27, 2012 at 07:02:45PM -0400, Eric Sandeen wrote:
> On 6/27/12 3:30 PM, Theodore Ts'o wrote:
> > A better workload would be to use a blocksize of 4k.  By using a
> > blocksize of 1024k, it's not surprising that the metadata overhead is
> > in the noise.
> > 
> > Try something like this; this will cause the extent tree overhead to
> > be roughly equal to the data block I/O.
> > 
> > [global]
> > rw=randwrite
> > size=128m
> > filesize=1g
> > bs=4k
> > ioengine=sync
> > fallocate=1
> > fsync=1
> > 
> > [thread1]
> > filename=testfile

Hi Eric,

Could you please run this test with 'journal_async_commit' flag.  In my
previous test, this feature can dramatically improve the performance of
uninitialized extent conversion.

I have sent an email to do a similar test [1].  In that email, I do a
similar test and the journal_async_commit flag quite can improve the
performance.

1. http://comments.gmane.org/gmane.linux.file-systems/63569

Regards,
Zheng
