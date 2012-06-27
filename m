From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4_fallocate
Date: Wed, 27 Jun 2012 15:30:34 -0400
Message-ID: <20120627193034.GA3198@thunk.org>
References: <4FE8086F.4070506@zoho.com>
 <20120625085159.GA18931@gmail.com>
 <20120625191744.GB9688@thunk.org>
 <4FE9B57F.4030704@redhat.com>
 <4FE9F9F4.7010804@zoho.com>
 <4FEA0DD1.8080403@gmail.com>
 <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <ricwheeler@gmail.com>, Fredrick <fjohnber@zoho.com>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53111 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab2F0Tal (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 15:30:41 -0400
Content-Disposition: inline
In-Reply-To: <4FEA1F18.6010206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 26, 2012 at 04:44:08PM -0400, Eric Sandeen wrote:
> > 
> > I tried running this fio recipe on v3.3, which I think does a decent job of
> > emulating the situation (fallocate 1G, do random 1M writes into it, with
> > fsyncs after each):
> > 
> > [test]
> > filename=testfile
> > rw=randwrite
> > size=1g
> > filesize=1g
> > bs=1024k
> > ioengine=sync
> > fallocate=1
> > fsync=1

A better workload would be to use a blocksize of 4k.  By using a
blocksize of 1024k, it's not surprising that the metadata overhead is
in the noise.

Try something like this; this will cause the extent tree overhead to
be roughly equal to the data block I/O.

[global]
rw=randwrite
size=128m
filesize=1g
bs=4k
ioengine=sync
fallocate=1
fsync=1

[thread1]
filename=testfile

					- Ted
