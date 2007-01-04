From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH 1/1 version2] Extent overlap bugfix in ext4
Date: Thu, 04 Jan 2007 22:19:45 +0300
Message-ID: <m3ejqaeh0u.fsf@bzzz.home.net>
References: <20070102090909.GA20503@amitarora.in.ibm.com>
	<1167788128.4197.17.camel@dyn9047017103.beaverton.ibm.com>
	<20070103060601.GB5343@amitarora.in.ibm.com>
	<20070104085407.GC5345@amitarora.in.ibm.com>
	<m3zm8zdqjn.fsf@bzzz.home.net>
	<20070104112707.GB15920@amitarora.in.ibm.com>
	<m3r6ubdnuj.fsf@bzzz.home.net>
	<20070104172329.GA23612@amitarora.in.ibm.com>
	<459D4C58.5010502@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:48462 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750967AbXADTUM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Jan 2007 14:20:12 -0500
To: Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <459D4C58.5010502@us.ibm.com> (Mingming Cao's message of "Thu\, 04
	Jan 2007 10\:50\:00 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Mingming Cao (MC) writes:

 MC> Hi, Amit,
 MC> Have you looked at ext4_ext_walk_space()? It calculate the right
 MC> extent length to allocate to avoid overlap before calling block
 MC> allocation callback function is called.

well, it doesn't use cache. 

 MC> What if the start logical block of the exisitng extent is 0 and there
 MC> is overlap? I think that is possible. For example, the exisitng extent
 MC> is (0,100) and you want to insert new extent (0,500), this will
 MC> certainly fail to report the overlap.

I think this situation must not happen in the first place.
get_blocks() should first find existing blocks and return them
(0,100), subsequent get_blocks() should be called for the
following blocks (100,500) and handle them properly.

 MC> Since this overlap check function is called inside
 MC> ext4_ext_insert_extent(), I think this function should check for all
 MC> kinds of overlaps. Here you only check if the new extent is overlap
 MC> with the next extent. Looking at ext4_ext_walk_space(), there are
 MC> total three kinds of overlaps:
 MC> 1) righ port of new extent overlap with path->p_ext,
 MC> 2) left port of new extent overlap with path->p_ext
 MC> 2) right port of new extent overlap with next extent

 MC> I think we are almost repeating the same logic in
 MC> ext4_ext_walk_space() here.

I tend to agree.

thanks, Alex
