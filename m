From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Thu, 04 Jan 2007 14:37:40 +0300
Message-ID: <m3r6ubdnuj.fsf@bzzz.home.net>
References: <20070102090909.GA20503@amitarora.in.ibm.com>
	<1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com>
	<20070103060601.GB5343@amitarora.in.ibm.com>
	<20070104085407.GC5345@amitarora.in.ibm.com>
	<m3zm8zdqjn.fsf@bzzz.home.net>
	<20070104112707.GB15920@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:39668 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964795AbXADLhz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jan 2007 06:37:55 -0500
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20070104112707.GB15920@amitarora.in.ibm.com> (Amit K. Arora's
	message of "Thu\, 4 Jan 2007 16\:57\:07 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Amit K Arora (AKA) writes:

 AT> I'm also not sure we need ext4_ext_find_extent() here.
 AKA> Do you mean ext4_ext_next_allocated_block() above ? We anyhow have to
 AKA> call find_extent() to get the possible neighbouring extent.

no, I exactly meant ext4_ext_find_extent(). it's expensive
compared to ext4_ext_next_allocated_block().
and if I understand right, you don't need whole extent, you
just need to know next allocated block, which can be retrieved
from index even. this is what ext4_ext_next_allocated_block() does.

 AT> there are two possibilities:
 >> 
 AT> 1) extent in found path covers block(s) before requested ones
 AT> then ext4_ext_next_allocated_block(path) can be used
 >> 
 AT> 2) extent in found path covers block(s) after request ones
 AT> then ee_block from that extent can be used.

 AKA> You are right. In the case the requested block(s) lie within a hole, when
 AKA> this hole starts from the begining of the file, this will be true. i.e.,
 AKA> find_blocks() will return the extent after the requested block(s). In all
 AKA> other cases, it will return the extent before the requested block(s)
 AKA> (assuming there is no existing extent which covers the start of the
 AKA> requested blocks).

existing blocks are to be handled properly in get_blocks():

	/* if found extent covers block, simply return it */
        if (iblock >= ee_block && iblock < ee_block + ee_len) {
		newblock = iblock - ee_block + ee_start;
		/* number of remaining blocks in the extent */
		allocated = ee_len - (iblock - ee_block);
		ext_debug("%d fit into %lu:%d -> %llu\n", (int) iblock,
				ee_block, ee_len, newblock);
		ext4_ext_put_in_cache(inode, ee_block, ee_len,
				      ee_start, EXT4_EXT_CACHE_EXTENT);

 AKA> Will change the code accordingly to handle this corner case. Thanks for
 AKA> pointing this out !

my pleasure.

thanks, Alex
