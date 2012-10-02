From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] ext3: ext3_bread usage audit
Date: Tue, 2 Oct 2012 11:27:23 -0300
Message-ID: <20121002142723.GA2323@andromeda.usersys.redhat.com>
References: <1349121055-8168-1-git-send-email-cmaiolino@redhat.com>
 <1349121055-8168-3-git-send-email-cmaiolino@redhat.com>
 <20121002135513.GE22777@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab2JBO11 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Oct 2012 10:27:27 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q92ERRCB019669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2012 10:27:27 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-65.phx2.redhat.com [10.3.113.65])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q92EROdi020255
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2012 10:27:26 -0400
Content-Disposition: inline
In-Reply-To: <20121002135513.GE22777@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan
On Tue, Oct 02, 2012 at 03:55:13PM +0200, Jan Kara wrote:
> On Mon 01-10-12 16:50:55, Carlos Maiolino wrote:
> > This is the ext3 version of the same patch applied to Ext4, where such goal is
> > to audit the usage of ext3_bread() due a possible misinterpretion of its return
> > value.
> > 
> > Focused on directory blocks, a NULL value returned from ext3_bread() means a
> > hole, which cannot exist into a directory inode. It can pass undetected after a
> > fix in an uninitialized error variable.
> > 
> > The (now) initialized variable into ext3_getblk() may lead to a zero'ed return
> > value of ext3_bread() to its callers, which can make the caller do not detect
> > the hole in the directory inode.
> > 
> > This checks for directory holes when buffer_head and error value are both
> > zero'ed returning -EIO to their callers
> > 
> > Some ext3_bread() callers do not needed any changes either because they already
> > had its own hole detector paths or because these are deprecaded (like
> > dx_show_entries)
>   Umm, can you wrap the check for hole + error message in a helper function
> like ext3_dir_bread() please? That would save us quite some dupplication..
> Thanks!
>
I thought about a kind of handler too, but haven't done something like that by
Ted's suggestion. Please see thread
http://marc.info/?l=linux-ext4&m=134827512716575&w=2

But I can work on a kind of wrapper for ext3 if this is ok for you and send a V2
version of this patch.

Cheers,
Carlos  

-- 
--Carlos
