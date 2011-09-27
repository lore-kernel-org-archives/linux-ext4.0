From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch 1/1]
 ext4-fix-dirty-extent-when-origin-leaf-extent-reac.patch
Date: Tue, 27 Sep 2011 15:35:23 -0400
Message-ID: <20110927193523.GB3309@thunk.org>
References: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl>
 <20110906145347.GA4133@dumpdata.com>
 <BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl>
 <4E666C86.5090707@goop.org>
 <BLU157-W323C330706CB8D7E976BC3DA1F0@phx.gbl>
 <BLU157-W7DABA5FE01C50C29B1A64DA060@phx.gbl>
 <BLU157-W25EB1EAC24CC11FA14859ADAF20@phx.gbl>
 <20110926142808.GG4102@phenom.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: MaoXiaoyun <tinnycloud@hotmail.com>, linux-ext4@vger.kernel.org,
	xen devel <xen-devel@lists.xensource.com>, jack@suse.cz
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57872 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271Ab1I0Tf0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Sep 2011 15:35:26 -0400
Content-Disposition: inline
In-Reply-To: <20110926142808.GG4102@phenom.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 26, 2011 at 10:28:08AM -0400, Konrad Rzeszutek Wilk wrote:
> >  
> >    Attached is the fix, verified in our env. 
> 
> So.. you are asking for this upstream git commit to be back-ported
> to 2.6.32, right?

I'm curious --- is there a good reason why Xen users are using an
upstream 2.6.32 kernel?  If they are using a distro kernel, fine, but
then the distro kernel should be providing the support.  But at this
point, 2.6.32 is so positively *ancient* that, I'm personally not
interesting in providing free, unpaid distro support for users who
aren't willing to either (a) pay $$$ and get a supported distro
kernel, or (b) use a much more modern kernel.  At this point, Guest
and Host Xen support is available in 3.0 kernels, so there's really no
excuse, right?

						- Ted
