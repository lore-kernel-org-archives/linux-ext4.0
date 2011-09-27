From: MaoXiaoyun <tinnycloud@hotmail.com>
Subject: RE: [patch 1/1]
 ext4-fix-dirty-extent-when-origin-leaf-extent-reac.patch
Date: Tue, 27 Sep 2011 10:22:48 +0800
Message-ID: <BLU157-W54420DD5C05CB38610F67DAF00@phx.gbl>
References: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl>,<20110906145347.GA4133@dumpdata.com>,<BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl>,<4E666C86.5090707@goop.org>,<BLU157-W323C330706CB8D7E976BC3DA1F0@phx.gbl>,<BLU157-W7DABA5FE01C50C29B1A64DA060@phx.gbl>,<BLU157-W25EB1EAC24CC11FA14859ADAF20@phx.gbl>,<20110926142808.GG4102@phenom.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit
Cc: <linux-ext4@vger.kernel.org>,
	xen devel <xen-devel@lists.xensource.com>, <tytso@mit.edu>,
	<jack@suse.cz>, <jeremy@goop.org>
To: <konrad.wilk@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blu0-omc1-s18.blu0.hotmail.com ([65.55.116.29]:22856 "EHLO
	blu0-omc1-s18.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958Ab1I0CWt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Sep 2011 22:22:49 -0400
In-Reply-To: <20110926142808.GG4102@phenom.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>




----------------------------------------
> Date: Mon, 26 Sep 2011 10:28:08 -0400
> From: konrad.wilk@oracle.com
> To: tinnycloud@hotmail.com
> CC: linux-ext4@vger.kernel.org; xen-devel@lists.xensource.com; tytso@mit.edu; jack@suse.cz
> Subject: Re: [patch 1/1] ext4-fix-dirty-extent-when-origin-leaf-extent-reac.patch
>
> On Sun, Sep 25, 2011 at 04:45:39PM +0800, MaoXiaoyun wrote:
> >
> >
> > Hi:
> >
> > We met an ext4 BUG_ON in extents.c:1716 which crash kernel flush thread, and result in disk unvailiable.
> >
> > BUG details refer to: http://www.gossamer-threads.com/lists/xen/devel/217091?do=post_view_threaded
> >
> > Attached is the fix, verified in our env.
>
> So.. you are asking for this upstream git commit to be back-ported to 2.6.32, right?
>
 
The patch is for 2.6.39. It can be patched on 2.6.32 too.
Thanks.

> >
> > Without this patch, more than 3 servers hit BUG_ON in our hundreds of servers every day.
> >
> >
> > many thanks.
>
> 		 	   		  
