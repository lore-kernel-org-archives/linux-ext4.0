From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Fri, 10 Jul 2009 12:58:41 +0530
Message-ID: <20090710072841.GB19408@skywalker>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com> <20090617234604.GF7867@mit.edu> <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com> <20090701183130.GA31235@skywalker> <20090706034144.GB31532@mit.edu> <d5ca277e0907060921s72c93834yd98a96cb57809b4b@mail.gmail.com> <d5ca277e0907091130y5182debakc86d1f390396b92c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Xiang Wang <xiangw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52437 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZGJH2u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jul 2009 03:28:50 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id n6A7Qt6C023172
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 17:26:55 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6A7SmFF1269834
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 17:28:48 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6A7SmlH017153
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 17:28:48 +1000
Content-Disposition: inline
In-Reply-To: <d5ca277e0907091130y5182debakc86d1f390396b92c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 09, 2009 at 11:30:58AM -0700, Xiang Wang wrote:
> When working on the patch of adding the data=nojournal mount option,
> I start to wonder whether this mount option is actually needed.
> 
> When we mount a filesystem that was mkfs'ed with journal, using the
> "noload" mount option
> can help specify we do not load the journal.
> 
> When we mount a filesystem that was mkfs'ed without journal, we simply
> go into the
> nojournal mode.
> 
> That said, I do not really feel this data=nojournal option is necessary.
> But I am still working on the patch to print appropriate messages when
> people mount a filesystem
> created without a journal but explicitly specify the "data=" option.
> Any comments?
> 

Now that I look at commit 0390131ba84fd3f726f9e24fc4553828125700bb
if i understood correctly, that should always force a no journal 
mount to data=writeback ?

I tested it as below

 mkfs.ext4 -O ^has_journal /home/opensource/images/ext3.img
 sudo mount -o loop /home/opensource/images/ext3.img  /mnt/
[master@linux-2.6]$ cat /proc/mounts  | grep mnt
/dev/loop0 /mnt ext4 rw,relatime,barrier=1,data=writeback 0 0

So what we really need is to update ext4_should_writeback_data
not to return 0 when we  don't have a journal. Ted already have a patch
in the patch queue that does the same. I guess that patch should get
everything working fine.  So if mke2fs have created a journal to run
in no journal mode one can say -o noload. I guess that is more or less
what we wanted.

-aneesh
