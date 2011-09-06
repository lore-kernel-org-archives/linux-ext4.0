From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] RE: ext4 BUG in dom0 Kernel 2.6.32.36
Date: Tue, 06 Sep 2011 11:55:02 -0700
Message-ID: <4E666C86.5090707@goop.org>
References: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl>, <20110906145347.GA4133@dumpdata.com> <BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: konrad.wilk@oracle.com, linux-ext4@vger.kernel.org,
	xen devel <xen-devel@lists.xensource.com>
To: MaoXiaoyun <tinnycloud@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from claw.goop.org ([74.207.240.146]:50841 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab1IFSzG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 14:55:06 -0400
In-Reply-To: <BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/06/2011 08:11 AM, MaoXiaoyun wrote:
>
> > Date: Tue, 6 Sep 2011 10:53:47 -0400
> > From: konrad.wilk@oracle.com
> > To: tinnycloud@hotmail.com
> > CC: linux-ext4@vger.kernel.org; xen-devel@lists.xensource.com;
> jeremy@goop.org
> > Subject: Re: ext4 BUG in dom0 Kernel 2.6.32.36
> >
> > On Tue, Sep 06, 2011 at 03:24:14PM +0800, MaoXiaoyun wrote:
> > >
> > >
> > > Hi:
> > >
> > > I've met an ext4 Bug in dom0 kernel 2.6.32.36. (See kernel stack
> below)
> >
> > Did you try the 3.0 kernel?
> No, I am afried the change would be to much for our current env.
> May result in other stable issue.
> So, I want to dig out what really happen. Hopes.

Another question is whether this is a regression compared to earlier
versions of 2.6.32? Do you know if this problem exists in a non-Xen
environment?

Thanks,
J
