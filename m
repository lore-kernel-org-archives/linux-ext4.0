From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix performance regression in writeback of random
 writes
Date: Wed, 11 Sep 2013 12:11:22 +0200
Message-ID: <20130911101122.GA2167@quack.suse.cz>
References: <1378842006-15237-1-git-send-email-jack@suse.cz>
 <52303B9F.5060507@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Yan Zheng <ukernel@gmail.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab3IKKLZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Sep 2013 06:11:25 -0400
Content-Disposition: inline
In-Reply-To: <52303B9F.5060507@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 11-09-13 11:45:03, Bernd Schubert wrote:
> On 09/10/2013 09:40 PM, Jan Kara wrote:
> >Linux Kernel Performance project guys have reported that commit 4e7ea81db5
> >introduces a performance regression for the following fio workload:
> >[global]
> >direct=0
> >ioengine=mmap
> >size=1500M
> >bs=4k
> >pre_read=1
> >numjobs=1
> >overwrite=1
> >loops=5
> >runtime=300
> >group_reporting
> >invalidate=0
> >directory=/mnt/
> >file_service_type=random:36
> >file_service_type=random:36
> >
> >[job0]
> >startdelay=0
> >rw=randrw
> >filename=data0/f1:data0/f2
> >
> >[job1]
> >startdelay=0
> >rw=randrw
> >filename=data0/f2:data0/f1
> >...
> >
> >[job7]
> >startdelay=0
> >rw=randrw
> >filename=data0/f2:data0/f1
> >
> >The culprit of the problem is that after the commit ext4_writepages()
> >are more aggressive in writing back pages. Thus we have less consecutive
> >dirty pages resulting in more seeking.
> >
> >This increased aggressivity is caused by a bug in the condition
> >terminating ext4_writepages(). We start writing from the beginning of
> >the file even if we should have terminated ext4_writepages() because
> >wbc->nr_to_write <= 0.
> >
> >After fixing the condition the throughput of the fio workload is about 20%
> >better than before writeback reorganization.
> >
> >Reported-by: "Yan, Zheng" <zheng.z.yan@intel.com>
> >Signed-off-by: Jan Kara <jack@suse.cz>
> >---
> >  fs/ext4/inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >index c79fd7d..7914c05 100644
> >--- a/fs/ext4/inode.c
> >+++ b/fs/ext4/inode.c
> >@@ -2563,7 +2563,7 @@ retry:
> >  			break;
> >  	}
> >  	blk_finish_plug(&plug);
> >-	if (!ret && !cycled) {
> >+	if (!ret && !cycled && wbc->nr_to_write > 0) {
> >  		cycled = 1;
> >  		mpd.last_page = writeback_index - 1;
> >  		mpd.first_page = 0;
> >
> 
> Interesting, doesn't that mean generic_writepages (sub-sequent
> write_cache_pages() ) and all other file systems implementing their
> own ->writepages()  should be updated?
  No. write_cache_pages() has the condition like:
if (!cycled && !done) {

  and 'done' is set when wbc->nr_to_write drops to zero. So that function
is OK. We cannot use 'done' in ext4_writepages() because the functions are
structured a bit differently and 'done' gets set also when reach end of
file.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
