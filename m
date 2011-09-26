From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [patch 1/1]
 ext4-fix-dirty-extent-when-origin-leaf-extent-reac.patch
Date: Mon, 26 Sep 2011 10:28:08 -0400
Message-ID: <20110926142808.GG4102@phenom.oracle.com>
References: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl>
 <20110906145347.GA4133@dumpdata.com>
 <BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl>
 <4E666C86.5090707@goop.org>
 <BLU157-W323C330706CB8D7E976BC3DA1F0@phx.gbl>
 <BLU157-W7DABA5FE01C50C29B1A64DA060@phx.gbl>
 <BLU157-W25EB1EAC24CC11FA14859ADAF20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	xen devel <xen-devel@lists.xensource.com>, tytso@mit.edu,
	jack@suse.cz
To: MaoXiaoyun <tinnycloud@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:27649 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1IZO2a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Sep 2011 10:28:30 -0400
Content-Disposition: inline
In-Reply-To: <BLU157-W25EB1EAC24CC11FA14859ADAF20@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 25, 2011 at 04:45:39PM +0800, MaoXiaoyun wrote:
> 
>  
> Hi:
>  
>    We met an ext4 BUG_ON in extents.c:1716 which crash kernel flush thread, and result in disk unvailiable.
>  
>    BUG details refer to: http://www.gossamer-threads.com/lists/xen/devel/217091?do=post_view_threaded
>  
>    Attached is the fix, verified in our env. 

So.. you are asking for this upstream git commit to be back-ported to 2.6.32, right?

>  
>    Without this patch, more than 3 servers hit BUG_ON in our hundreds of servers every day.
>  
>    
>    many thanks. 		 	   		  


