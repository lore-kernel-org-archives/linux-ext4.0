From: MaoXiaoyun <tinnycloud@hotmail.com>
Subject: RE: [patch 1/1]
 ext4-fix-dirty-extent-when-origin-leaf-extent-reac.patch
Date: Wed, 28 Sep 2011 12:09:39 +0800
Message-ID: <BLU157-W95100AF9A3CA3897D3964DAF10@phx.gbl>
References: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl>,<20110906145347.GA4133@dumpdata.com>,<BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl>,<4E666C86.5090707@goop.org>,<BLU157-W323C330706CB8D7E976BC3DA1F0@phx.gbl>,<BLU157-W7DABA5FE01C50C29B1A64DA060@phx.gbl>,<BLU157-W25EB1EAC24CC11FA14859ADAF20@phx.gbl>,<20110926142808.GG4102@phenom.oracle.com>,<20110927193523.GB3309@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit
Cc: <linux-ext4@vger.kernel.org>,
	xen devel <xen-devel@lists.xensource.com>, <jack@suse.cz>,
	<jeremy@goop.org>
To: <tytso@mit.edu>, <konrad.wilk@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blu0-omc3-s7.blu0.hotmail.com ([65.55.116.82]:33411 "EHLO
	blu0-omc3-s7.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738Ab1I1EJk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Sep 2011 00:09:40 -0400
In-Reply-To: <20110927193523.GB3309@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>




----------------------------------------
> Date: Tue, 27 Sep 2011 15:35:23 -0400
> From: tytso@mit.edu
> To: konrad.wilk@oracle.com
> CC: tinnycloud@hotmail.com; linux-ext4@vger.kernel.org; xen-devel@lists.xensource.com; jack@suse.cz
> Subject: Re: [patch 1/1] ext4-fix-dirty-extent-when-origin-leaf-extent-reac.patch
>
> On Mon, Sep 26, 2011 at 10:28:08AM -0400, Konrad Rzeszutek Wilk wrote:
> > >
> > > Attached is the fix, verified in our env.
> >
> > So.. you are asking for this upstream git commit to be back-ported
> > to 2.6.32, right?
>
> I'm curious --- is there a good reason why Xen users are using an
> upstream 2.6.32 kernel? If they are using a distro kernel, fine, but
> then the distro kernel should be providing the support. But at this
> point, 2.6.32 is so positively *ancient* that, I'm personally not
> interesting in providing free, unpaid distro support for users who
> aren't willing to either (a) pay $$$ and get a supported distro
> kernel, or (b) use a much more modern kernel. At this point, Guest
> and Host Xen support is available in 3.0 kernels, so there's really no
> excuse, right?

Mmm...
 
We first met this bug at pvops kernel(jeremy's tree, 2.6.32.36). 
 
We failed to find any related fix from google, so we debug the bug ourself.
Fortunately, we located root cause and thought some other xen users might
have this problem as well, that's why we sent out the fix to Xen-devel.
 
We go through the code from 2.6.32 - 2.6.39, this bug exists.
People who use *ancient* kernel need this. 
 
Thanks.

> - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html 		 	   		  
