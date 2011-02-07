From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
Date: Mon, 7 Feb 2011 12:45:52 -0500
Message-ID: <20110207174552.GC3457@thunk.org>
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Matt <jackdachef@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45268 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab1BGRpz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 12:45:55 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 04, 2011 at 10:40:47PM +0000, Matt wrote:
> 
> So that means that the file-corruption which existed until 2.6.37-rc6
> and got triggered (for me) more easily via "dm crypt: scale to
> multiple CPUs"
> is fixed now ?

Well, a patch exists for it that will be merged into 2.6.38.

> That should give ext4 a nice speedup for >=2.6.38 :)

I'm not going to make it be the default for 2.6.38, since it's fairly
late in the -rc features.  People who want it can explicitly enable it
using the mount option mblk_io_submit, though.  (And let me know your
success stories!  :-) I will be enabling it as the default in
2.6.39-rc1.

> Reported-by: Matthias Bayer <jackdachef <at> gmail <dot> com >

Sure!

						- Ted
