From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: mballoc: fix mb_normalize_request algorithm for
	1KB block size filesystems
Date: Fri, 02 May 2008 14:12:13 -0700
Message-ID: <1209762733.3609.11.camel@localhost.localdomain>
References: <1209562870.5307.12.camel@ext1.frec.bull.fr>
	 <20080501171410.GC7005@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>, sandeen@redhat.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54939 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759676AbYEBVM0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2008 17:12:26 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m42LCN4D004110
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 17:12:23 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m42LCOa2182520
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 17:12:24 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m42LCNwq030027
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 17:12:23 -0400
In-Reply-To: <20080501171410.GC7005@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-05-01 at 22:44 +0530, Aneesh Kumar K.V wrote:
> On Wed, Apr 30, 2008 at 03:41:10PM +0200, Valerie Clement wrote:
> > mballoc: fix mb_normalize_request algorithm for 1KB block size filesystems
> > 
> > From: Valerie Clement <valerie.clement@bull.net>
> > 
> > In case of inode preallocation, the number of blocks to allocate depends
> > on the file size and it is calculated in ext4_mb_normalize_group_request().
> > Each group in the filesystem is then checked to find one that can be used
> > for allocation; this is done in ext4_mb_good_group().
> > 
> > When a file bigger than 4MB is created, the requested number of blocks to
> > preallocate, calculated by ext4_mb_normalize_group_request is 4096.
> > However for a filesystem with 1KB block size, the maximum size of the
> > block buddies used by the multiblock allocator is 2048, so none of
> > groups in the filesystem satisfies the search criteria in
> > ext4_mb_good_group(). Scanning all the filesystem groups impacts
> > performance.
> 
> s/ext4_mb_normalize_group_request/ext4_mb_normalize_request/
> 
> 
> That's true the max order is block_size_bits + 1
> Can you update the commit message with the above information ?
> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> 

Ok, Updated patch queue with the comment changes. Also fixed a small
checkpatch warning:-)

Mingming
> > 
> > The following numbers show that:
> > - on an ext4 FS with 1KB block size mounted with nodelalloc option:
> > # dd if=/dev/zero of=/mnt/test/foo bs=8k count=1k conv=fsync
> > 1024+0 records in
> > 1024+0 records out
> > 8388608 bytes (8.4 MB) copied, 35.5091 seconds, 236 kB/s
> > 
> > - on an ext4 FS with 1KB block size mounted with nodelalloc and nomballoc
> > options:
> > # dd if=/dev/zero of=/mnt/test/foo bs=8k count=1k conv=fsync
> > 1024+0 records in
> > 1024+0 records out
> > 8388608 bytes (8.4 MB) copied, 0.233754 seconds, 35.9 MB/s
> > 
> > In the two cases, dd is done after creating the FS with -b1024 option,
> > mounting the FS with the options specified before and flushing all caches
> > using echo 3 > /proc/sys/vm/drop_caches.
> > The partition size is 70GB.
> > I did the same test on a 1TB partition, it took several minutes to write
> > 8MB!
> > 
> > This patch modifies the algorithm in ext4_mb_normalize_group_request to
> > calculate the number of blocks to allocate by taking into account the
> > maximum size of free blocks chunks handled by the multiblock allocator.
> > 
> > It has also been tested for filesystems with 2KB and 4KB block sizes to
> > ensure that those cases don't regress.
> > 
> > Signed-off-by: Valerie Clement <valerie.clement@bull.net>
> > 
> > ---
> > 
> >  mballoc.c |   19 +++++++++----------
> >  1 file changed, 9 insertions(+), 10 deletions(-)
> > 
> > Index: linux-2.6.25/fs/ext4/mballoc.c
> > ===================================================================
> > --- linux-2.6.25.orig/fs/ext4/mballoc.c	2008-04-25 16:19:32.000000000 +0200
> > +++ linux-2.6.25/fs/ext4/mballoc.c	2008-04-25 16:49:34.000000000 +0200
> > @@ -2905,12 +2905,11 @@ ext4_mb_normalize_request(struct ext4_al
> >  	if (size < i_size_read(ac->ac_inode))
> >  		size = i_size_read(ac->ac_inode);
> > 
> > -	/* max available blocks in a free group */
> > -	max = EXT4_BLOCKS_PER_GROUP(ac->ac_sb) - 1 - 1 -
> > -				EXT4_SB(ac->ac_sb)->s_itb_per_group;
> > +	/* max size of free chunks */
> > +	max = 2 << bsbits;
> > 
> > -#define NRL_CHECK_SIZE(req, size, max,bits)	\
> > -		(req <= (size) || max <= ((size) >> bits))
> > +#define NRL_CHECK_SIZE(req, size, max, chunk_size)	\
> > +		(req <= (size) || max <= (chunk_size))
> > 
> >  	/* first, try to predict filesize */
> >  	/* XXX: should this table be tunable? */
> > @@ -2929,16 +2928,16 @@ ext4_mb_normalize_request(struct ext4_al
> >  		size = 512 * 1024;
> >  	} else if (size <= 1024 * 1024) {
> >  		size = 1024 * 1024;
> > -	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, bsbits)) {
> > +	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, 2 * 1024)) {
> >  		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
> > -						(20 - bsbits)) << 20;
> > -		size = 1024 * 1024;
> > -	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, bsbits)) {
> > +						(21 - bsbits)) << 21;
> > +		size = 2* 1024 * 1024;
> > +	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, 4 * 1024)) {
> >  		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
> >  							(22 - bsbits)) << 22;
> >  		size = 4 * 1024 * 1024;
> >  	} else if (NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,
> > -					(8<<20)>>bsbits, max, bsbits)) {
> > +					(8<<20)>>bsbits, max, 8 * 1024)) {
> >  		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
> >  							(23 - bsbits)) << 23;
> >  		size = 8 * 1024 * 1024;
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

