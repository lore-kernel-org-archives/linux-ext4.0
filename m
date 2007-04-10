From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: (un)lock_kernel() ?
Date: Tue, 10 Apr 2007 11:10:19 -0500
Message-ID: <1176221419.10818.6.camel@kleikamp.austin.ibm.com>
References: <alpine.DEB.0.83.0704040853450.28216@sigma.j-a-k-j.com>
	 <1175701002.6489.4.camel@shaggy>
	 <alpine.DEB.0.83.0704041244560.4770@sigma.j-a-k-j.com>
	 <1176220995.3696.24.camel@fs0004.ibrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
	linux-ext4@vger.kernel.org
To: blackmagic02881@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47257 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031000AbXDJQKV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Apr 2007 12:10:21 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3AGB3gU002702
	for <linux-ext4@vger.kernel.org>; Tue, 10 Apr 2007 12:11:03 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3AGAKcG195706
	for <linux-ext4@vger.kernel.org>; Tue, 10 Apr 2007 12:10:20 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3AGAJde009548
	for <linux-ext4@vger.kernel.org>; Tue, 10 Apr 2007 12:10:20 -0400
In-Reply-To: <1176220995.3696.24.camel@fs0004.ibrix.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-04-10 at 12:03 -0400, Ming Zhang wrote:
> On Wed, 2007-04-04 at 12:52 -0400, John Anthony Kazos Jr. wrote:
> > > According to Documentation/filesystems/Locking, ->get_sb() is called
> > > with the BKL held, but looking through the code, I'm not able to find
> > > where it is being taken.
> > 
> > I noticed that too. Unless I'm just dumb and can't see it, I'm not able to 
> > find any BKL references during filesystem mounting until you get into 
> > FS-specific code. I looked through everything from sys_mount through to 
> > vfs_kern_mount. Documentation/filesystems/porting talks about several 
> > situations where the VFS code was modified to not take the BKL, and BLK 
> > calls were added by FS non-maintainers for safety until each FS could be 
> > audited independently, but that wouldn't be the case, would it?
> 
> 
> sys_mount->do_mount->do_new_mount->do_kern_mount path
> 
> part of sys_mount()
> 
> 1570                 goto out3;
> 1571 
> 1572         lock_kernel();
> 1573         retval = do_mount((char *)dev_page, dir_page, (char *)type_page,
> 1574                           flags, (void *)data_page);
> 1575         unlock_kernel();
> 1576         free_page(data_page);
> 1577 
> 1578 out3:
> 1579         free_page(dev_page)

Thanks.  I missed that somehow.  It seems the documentation is correct.
-- 
David Kleikamp
IBM Linux Technology Center
