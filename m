From: Christoph Hellwig <hch@infradead.org>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Fri, 17 Aug 2012 13:48:41 -0400
Message-ID: <20120817174841.GA4519@infradead.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com>
 <20120816024654.GB3781@thunk.org>
 <20120816111051.GA16036@localhost>
 <20120816152513.GA31346@thunk.org>
 <20120817060110.GA28786@localhost>
 <20120817131558.GA11439@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Marti Raudsepp <marti@juffo.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55572
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756098Ab2HQRsz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 13:48:55 -0400
Content-Disposition: inline
In-Reply-To: <20120817131558.GA11439@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 17, 2012 at 09:15:58AM -0400, Theodore Ts'o wrote:
> Thanks Fengguang:
> 
> For the record, I was able to find my own easy repro, last night using
> only a 220 meg partition:
> 
> # mke2fs -t ext4 -b 1024 -J size=1 /dev/vdc
> # mount -t ext2 /dev/vdc /vdc
> # mkdir /vdc/a
> # cd /vdc/a
> # seq 1 210000  | xargs -n 1 fallocate -l 1m
> # seq 1 2 210000  | xargs /bin/rm
> # mkdir /vdc/b
> # cd /vdc/b
> # seq 1 103 | xargs -n 1 fallocate -l 1g
> # cd /
> # umount /vdc
> # mount -t ext4 -o commit=10000 /dev/vdc /vdc
> # rm -rf /vdc/b

Can you submit this for xfstests?

