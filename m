From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: corruption on 3.1.0-rc9-next-20111011+
Date: Mon, 17 Oct 2011 12:08:47 +0300
Message-ID: <20111017090847.GO30887@longonot.mountain>
References: <20111017065700.GO18470@longonot.mountain>
 <20111017081036.GN30887@longonot.mountain>
 <4E9BEC7D.8070904@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:24609 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1JQJLw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Oct 2011 05:11:52 -0400
Content-Disposition: inline
In-Reply-To: <4E9BEC7D.8070904@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 17, 2011 at 04:51:09PM +0800, Tao Ma wrote:
> Hi Dan,
> On 10/17/2011 04:10 PM, Dan Carpenter wrote:
> > On Mon, Oct 17, 2011 at 09:57:00AM +0300, Dan Carpenter wrote:
> >> Hi list,
> >>
> >> I hit a sanity check in ext4_ext_insert_index() and my filesystem
> >> went read only.
> >>
> > 
> > Hm...  That's odd.  My netbook hit the same bug last night as well.
> > It's running the same kernel version and config but compiled on a
> > different system.  I don't know why it has the '+' char on the end of
> > the version name.  Maybe it always does that for linux-next, because
> > I don't have any patches applied.
> > 
> > I've left it with the readonly filesystem for now.
> This is caused by the commit 4fd30c033. Sorry for the trouble and please
> check the patch I just sent. It should resolve the warning.
> 

Thanks.

I don't have a way to reproduce the bug.  Once I get a system fixed
enough to install a new kernel, the problem has gone away.  I've was
running the old kernel for days before seeing the issue.

regards,
dan carpenter

