From: MaoXiaoyun <tinnycloud@hotmail.com>
Subject: RE: [Xen-devel] RE: ext4 BUG in dom0 Kernel 2.6.32.36
Date: Wed, 7 Sep 2011 10:35:21 +0800
Message-ID: <BLU157-W323C330706CB8D7E976BC3DA1F0@phx.gbl>
References: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl>,
 <20110906145347.GA4133@dumpdata.com>
 <BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl>,<4E666C86.5090707@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit
Cc: <konrad.wilk@oracle.com>, <linux-ext4@vger.kernel.org>,
	xen devel <xen-devel@lists.xensource.com>
To: <jeremy@goop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blu0-omc1-s26.blu0.hotmail.com ([65.55.116.37]:19559 "EHLO
	blu0-omc1-s26.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934Ab1IGCfX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Sep 2011 22:35:23 -0400
In-Reply-To: <4E666C86.5090707@goop.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>




----------------------------------------
> Date: Tue, 6 Sep 2011 11:55:02 -0700
> From: jeremy@goop.org
> To: tinnycloud@hotmail.com
> CC: konrad.wilk@oracle.com; linux-ext4@vger.kernel.org; xen-devel@lists.xensource.com
> Subject: Re: [Xen-devel] RE: ext4 BUG in dom0 Kernel 2.6.32.36
>
> On 09/06/2011 08:11 AM, MaoXiaoyun wrote:
> >
> > > Date: Tue, 6 Sep 2011 10:53:47 -0400
> > > From: konrad.wilk@oracle.com
> > > To: tinnycloud@hotmail.com
> > > CC: linux-ext4@vger.kernel.org; xen-devel@lists.xensource.com;
> > jeremy@goop.org
> > > Subject: Re: ext4 BUG in dom0 Kernel 2.6.32.36
> > >
> > > On Tue, Sep 06, 2011 at 03:24:14PM +0800, MaoXiaoyun wrote:
> > > >
> > > >
> > > > Hi:
> > > >
> > > > I've met an ext4 Bug in dom0 kernel 2.6.32.36. (See kernel stack
> > below)
> > >
> > > Did you try the 3.0 kernel?
> > No, I am afried the change would be to much for our current env.
> > May result in other stable issue.
> > So, I want to dig out what really happen. Hopes.
>
> Another question is whether this is a regression compared to earlier
> versions of 2.6.32? Do you know if this problem exists in a non-Xen
> environment?
>
 
There are some others reports this issue in non-xen env.
http://markmail.org/message/ywr4nfgiuvgdcr7y
http://www.spinics.net/lists/linux-ext4/msg21066.html
 
The difficulty is I haven't find a efficient way to reproduce it.
(Currently it only show in our cluster, redeploy our cluster may cost 3days more. )
 

> Thanks,
> J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html 		 	   		  
