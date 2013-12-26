From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] e2image: perform in-place move
Date: Wed, 25 Dec 2013 23:48:57 -0500
Message-ID: <20131226044857.GA13533@thunk.org>
References: <52AF2AC0.2030103@ubuntu.com>
 <1387211599-25789-1-git-send-email-psusi@ubuntu.com>
 <20131225045826.GC13142@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ttytso@mit.edu, linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43444 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab3LZEtC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Dec 2013 23:49:02 -0500
Content-Disposition: inline
In-Reply-To: <20131225045826.GC13142@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 24, 2013 at 11:58:26PM -0500, Theodore Ts'o wrote:
> On Mon, Dec 16, 2013 at 11:33:19AM -0500, Phillip Susi wrote:
> > If given at least one offset and only one file, assume source
> > and dest are the same, and do an in place move.
> > 
> > Signed-off-by: Phillip Susi <psusi@ubuntu.com>
> 
> Thanks, applied.

Sigh, I've had to revert this change since it is causing test
failures.  **Please** run the regression test suite before you submit
patches.

					- Ted

Contents of i_e2image.failed:

e2image -r i_e2image/image1024.orig _image.raw
e2image 1.42.8 (20-Jun-2013)
e2image -Q i_e2image/image1024.orig _image.qcow2
e2image 1.42.8 (20-Jun-2013)
e2image -r _image.qcow2 _image.qcow2.raw
e2image 1.42.8 (20-Jun-2013)
e2image -r i_e2image/image2048.orig _image.raw
e2image 1.42.8 (20-Jun-2013)
e2image -Q i_e2image/image2048.orig _image.qcow2
e2image 1.42.8 (20-Jun-2013)
e2image -r _image.qcow2 _image.qcow2.raw
e2image 1.42.8 (20-Jun-2013)
e2image -r i_e2image/image4096.orig _image.raw
e2image 1.42.8 (20-Jun-2013)
e2image -Q i_e2image/image4096.orig _image.qcow2
e2image 1.42.8 (20-Jun-2013)
e2image -r _image.qcow2 _image.qcow2.raw
e2image 1.42.8 (20-Jun-2013)
md5sums:
i_e2image/image1024.orig
d34914e0da07bdae80ab02288118fae2  image1024.orig
bbef4e50d7237546c7d9c521d3df5b68  _image.raw
1d4eb39452bed097dcd2c5bcd57180e6  _image.qcow2
bbef4e50d7237546c7d9c521d3df5b68  _image.qcow2.raw
i_e2image/image2048.orig
aa9f702de181188f2a6d2c5158686c09  image2048.orig
e097e571c809ec5418f060e2a2ec1737  _image.raw
52dba396b0fc338b99defcb086058d80  _image.qcow2
e097e571c809ec5418f060e2a2ec1737  _image.qcow2.raw
i_e2image/image4096.orig
1d3e7f15b2ce9ca07aa23c32951c5176  image4096.orig
ebaddd9f5a62610d789adbbec4ee7f46  _image.raw
a72165eaffb6900889108fbd05002822  _image.qcow2
ebaddd9f5a62610d789adbbec4ee7f46  _image.qcow2.raw

8,10c8,10
< e6f8410d0690ef551bee0c2c0c642d8c  _image.raw
< dbbd9aa97c6c946b9122586bbd2a325a  _image.qcow2
< e6f8410d0690ef551bee0c2c0c642d8c  _image.qcow2.raw
---
> e097e571c809ec5418f060e2a2ec1737  _image.raw
> 52dba396b0fc338b99defcb086058d80  _image.qcow2
> e097e571c809ec5418f060e2a2ec1737  _image.qcow2.raw
13,15c13,15
< 734119dd8f240a33704139f8cdd8127c  _image.raw
< 85fdbf5a8451b24b36ab82a02196deb9  _image.qcow2
< 734119dd8f240a33704139f8cdd8127c  _image.qcow2.raw
---
> ebaddd9f5a62610d789adbbec4ee7f46  _image.raw
> a72165eaffb6900889108fbd05002822  _image.qcow2
> ebaddd9f5a62610d789adbbec4ee7f46  _image.qcow2.raw
