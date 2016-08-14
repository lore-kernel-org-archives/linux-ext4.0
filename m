From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: ext4: fix reference counting bug on block allocation error
Date: Sun, 14 Aug 2016 20:37:56 +0200
Message-ID: <57B0BA84.1000600@oracle.com>
References: <20160727052921.5B41C35574@git2.kroah.org>
 <20160814183206.GA11040@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43915 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbcHNSih (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Aug 2016 14:38:37 -0400
In-Reply-To: <20160814183206.GA11040@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/14/2016 08:32 PM, Greg KH wrote:
> Hi Vegard and ext4 developers,
>
> The patch below, in Linus's tree, references a patch in the Fixes: line
> that is not in Linus's tree (neither the git commit id, nor the subject
> line.)
>

It seems to exist?

 >> Fixes: 8556e8f3b6 ("ext4: Don't allow new groups to be added during 
block allocation")

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8556e8f3b6c4c11601ce1e9ea8090a6d8bd5daae

> That's a bit confusing, what is this patch supposed to be fixing up?
> What stable tree(s) should it go to if the original patch it fixes isn't
> even in any tree?

The referenced commit adds the ext4_mb_release_context(ac); line which
is what is causing problems because that releases the context which is
still in fact in use.

>
> confused,

Confused too :-)


Vegard
