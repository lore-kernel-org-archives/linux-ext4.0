From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Performance of ext4
Date: Fri, 27 Jun 2008 15:19:13 +0530
Message-ID: <20080627094913.GB32723@skywalker>
References: <Pine.LNX.4.64.0806200905070.3383@diagnostix.dwd.de> <20080623174508.GA7216@skywalker> <1214267492.27507.285.camel@BVR-FS.beaverton.ibm.com> <20080624030721.GB10469@skywalker> <20080624033349.GD10469@skywalker> <Pine.LNX.4.64.0806242103370.14795@diagnostix.dwd.de> <1214348318.27507.330.camel@BVR-FS.beaverton.ibm.com> <Pine.LNX.4.64.0806250856160.16081@diagnostix.dwd.de> <1214441199.27507.351.camel@BVR-FS.beaverton.ibm.com> <20080627091459.GA32723@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>, Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Solofo.Ramangalahy@bull.net, Nick Dokos <nicholas.dokos@hp.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:45969 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYF0Jun (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jun 2008 05:50:43 -0400
Content-Disposition: inline
In-Reply-To: <20080627091459.GA32723@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 27, 2008 at 02:44:59PM +0530, Aneesh Kumar K.V wrote:
> On Wed, Jun 25, 2008 at 05:46:39PM -0700, Mingming wrote:
> > 
> > On Wed, 2008-06-25 at 09:09 +0000, Holger Kiehl wrote:
> > > On Tue, 24 Jun 2008, Mingming wrote:
> > > 
> > > >
> > > > On Tue, 2008-06-24 at 21:12 +0000, Holger Kiehl wrote:
> > > >> Yes, with this patch applied on top of latest patch queue I no longer
> > > >> get truncated files, after running a short test. Tomorrow I will do some
> > > >> more thorough testing and use the patch you have send to me in a separate
> > > >> mail. The above patch did not apply but it was easy to apply by hand.
> > > >
> > > >
> > > > Thanks for quick response and test. I have updated the patch queue with
> > > > above patch merged. Please let me know if you still see apply issue and
> > > > file size update issue with current patch queue.
> > > >
> > > Thanks, it applies without any problems. However I still hit an oops. What
> > > I find strange is that I got the oops just as the benchmark is done and
> > > all process where shutting down. The same behaviour I reported here:
> > > http://www.ussg.iu.edu/hypermail/linux/kernel/0806.2/2113.html
> > > Only this time I got just one oops. This is on x86_64 system (4 Opteron CPU's
> > > and SW Raid 1+0). I have not seen this on my home system x86 (1 Dual Core
> > > and HW Raid). Anyway, here the dmesg output:
> > > 
> > > kjournald2 starting.  Commit interval 15 seconds
> > > EXT4 FS on md7, internal journal
> > > EXT4-fs: mounted filesystem with ordered data mode.
> > > EXT4-fs: file extents enabled
> > > EXT4-fs: mballoc enabled
> > > JBD: barrier-based sync failed on md7 - disabling barriers
> > > ------------[ cut here ]------------
> > > kernel BUG at fs/ext4/inode.c:1667!
> > 
> > Did not get a chance to look more closely today, but it's point to this
> > code in ext4_da_writepage()
> > 
> >  page_bufs = page_buffers(page);
> > 
> > and appearently it's BUG_ON at 
> >  BUG_ON(!PagePrivate(page)); in page_buffers().
> > 
> > 
> 
> Ok so we are doing the journal_commit and meanwhile shrink_page_list
> dropped the buffer. I guess what is happening is
> 
> 
> journal_submit_inode_data_buffers
> generic_writepages
> write_cache_pages
> pagevec_lookup_tag(..PAGECACHE_TAG_DIRTY,..)
> foreach(page)
> 							shrink_page_list
> 							lock_page
> 							ext4_releasepage
> 							try_to_free_buffers
> 							drop_buffers
> 							cancel_dirty_page
> 							unlock_page
> lock_page()
> BUG_ON(!PagePrivate(page));
> 
> 
> How about the below ? 

or update write_cache_pages not to call writepage if the page is not
dirty ?


diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ded57d5..0a13702 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -929,6 +929,11 @@ int write_cache_pages(struct address_space *mapping,
 				continue;
 			}
 
+			if (!PageDirty(page)) {
+				unlock_page(page);
+				continue;
+			}
+
 			ret = (*writepage)(page, wbc, data);
 
 			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
