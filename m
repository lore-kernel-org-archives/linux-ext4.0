From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Performance of ext4
Date: Fri, 27 Jun 2008 23:05:51 +0530
Message-ID: <20080627173551.GA24402@skywalker>
References: <1214267492.27507.285.camel@BVR-FS.beaverton.ibm.com> <20080624030721.GB10469@skywalker> <20080624033349.GD10469@skywalker> <Pine.LNX.4.64.0806242103370.14795@diagnostix.dwd.de> <1214348318.27507.330.camel@BVR-FS.beaverton.ibm.com> <Pine.LNX.4.64.0806250856160.16081@diagnostix.dwd.de> <1214441199.27507.351.camel@BVR-FS.beaverton.ibm.com> <20080627091459.GA32723@skywalker> <20080627094913.GB32723@skywalker> <20080627100024.GB3602@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming <cmm@us.ibm.com>, Holger Kiehl <Holger.Kiehl@dwd.de>,
	Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:49382 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbYF0RgE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2008 13:36:04 -0400
Content-Disposition: inline
In-Reply-To: <20080627100024.GB3602@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 27, 2008 at 12:00:24PM +0200, Jan Kara wrote:
> On Fri 27-06-08 15:19:13, Aneesh Kumar K.V wrote:
> > On Fri, Jun 27, 2008 at 02:44:59PM +0530, Aneesh Kumar K.V wrote:
> > > On Wed, Jun 25, 2008 at 05:46:39PM -0700, Mingming wrote:
> > > > 
> > > > On Wed, 2008-06-25 at 09:09 +0000, Holger Kiehl wrote:
> > > > > On Tue, 24 Jun 2008, Mingming wrote:
> > > > > 
> > > > > >
> > > > > > On Tue, 2008-06-24 at 21:12 +0000, Holger Kiehl wrote:
> > > > > >> Yes, with this patch applied on top of latest patch queue I no longer
> > > > > >> get truncated files, after running a short test. Tomorrow I will do some
> > > > > >> more thorough testing and use the patch you have send to me in a separate
> > > > > >> mail. The above patch did not apply but it was easy to apply by hand.
> > > > > >
> > > > > >
> > > > > > Thanks for quick response and test. I have updated the patch queue with
> > > > > > above patch merged. Please let me know if you still see apply issue and
> > > > > > file size update issue with current patch queue.
> > > > > >
> > > > > Thanks, it applies without any problems. However I still hit an oops. What
> > > > > I find strange is that I got the oops just as the benchmark is done and
> > > > > all process where shutting down. The same behaviour I reported here:
> > > > > http://www.ussg.iu.edu/hypermail/linux/kernel/0806.2/2113.html
> > > > > Only this time I got just one oops. This is on x86_64 system (4 Opteron CPU's
> > > > > and SW Raid 1+0). I have not seen this on my home system x86 (1 Dual Core
> > > > > and HW Raid). Anyway, here the dmesg output:
> > > > > 
> > > > > kjournald2 starting.  Commit interval 15 seconds
> > > > > EXT4 FS on md7, internal journal
> > > > > EXT4-fs: mounted filesystem with ordered data mode.
> > > > > EXT4-fs: file extents enabled
> > > > > EXT4-fs: mballoc enabled
> > > > > JBD: barrier-based sync failed on md7 - disabling barriers
> > > > > ------------[ cut here ]------------
> > > > > kernel BUG at fs/ext4/inode.c:1667!
> > > > 
> > > > Did not get a chance to look more closely today, but it's point to this
> > > > code in ext4_da_writepage()
> > > > 
> > > >  page_bufs = page_buffers(page);
> > > > 
> > > > and appearently it's BUG_ON at 
> > > >  BUG_ON(!PagePrivate(page)); in page_buffers().
> > > > 
> > > > 
> > > 

How about this ?

commit 174d555d8effb480a23d5dea8db698d1bc2cfa7d
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Fri Jun 27 23:04:28 2008 +0530

    ext4: call ext4_page_mkwrite even for MappedToDisk pages
    
    We can have pages that are fully mapped to disk. The
    mappedtodisk flag is used to indicate that every
    buffer_head in the page have a mapping block allocated
    on disk. But that doesn't gurantee that we have initialized
    those buffer_head and added it to page via page->private.
    This causes writepage to go BUGON when it find a page
    that have NULL page->private.
    
    The fix is to make sure we initialize the buffer_head and add
    it to page when we are going to write to the page. This can
    be done via ext4_page_mkwrite
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 10f1d5d..11ebe88 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3978,8 +3978,6 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 		goto out_unlock;
 	}
 	ret = 0;
-	if (PageMappedToDisk(page))
-		goto out_unlock;
 
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
