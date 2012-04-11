From: Christoph Hellwig <hch@infradead.org>
Subject: Re: What is e2initrd_helper?
Date: Wed, 11 Apr 2012 18:21:16 -0400
Message-ID: <20120411222116.GA20494@infradead.org>
References: <4F85A740.9080906@ubuntu.com>
 <4F85A965.3040008@redhat.com>
 <20120411182736.GH12044@thunk.org>
 <4F860359.8000603@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37103
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761355Ab2DKWVT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 18:21:19 -0400
Content-Disposition: inline
In-Reply-To: <4F860359.8000603@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 11, 2012 at 06:19:05PM -0400, Phillip Susi wrote:
> AFAIK, Ubuntu uses Debian's initramfs system... are you saying this is not the case?  If so, what's the difference?  When I attended the last UDS there was actually a push coming from the arm folks to do away with the initrd on systems that do not require it ( no LVM ) to accelerate boot time by not wasting time loading another file, which apparently is rather slow on the arm boot loader.

Both share initramfs-tools, but they don't use the same version and
really do things subtily different.  I've just spent far too much time
making something work in the Debian version just to notice it needs
major updates for Ubuntu.

