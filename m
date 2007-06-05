From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
 larger than 32-bit blocks (take 2).
Date: Tue, 5 Jun 2007 14:58:14 -0500
Message-ID: <20070605145814.2e9677f7@gara>
References: <20070601105234.4be40028@rx8>
	<20070601225441.GF5181@schatzie.adilger.int>
	<20070604113210.1a76934b@gara>
	<20070604175728.GT5181@schatzie.adilger.int>
	<1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>
	<20070605064109.2cb6bad7@gara>
	<1181049283.18452.0.camel@kleikamp.austin.ibm.com>
	<4665649D.8010302@bull.net>
	<20070605084937.7622258a@gara>
	<46656D40.4050505@bull.net>
	<20070605104657.13d60531@gara>
	<46658A42.7040105@bull.net>
	<1181065603.3839.8.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Laurent Vivier <Laurent.Vivier@bull.net>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38011 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762145AbXFET6o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 15:58:44 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l55JsLke009307
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 15:54:21 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l55JwWjh253726
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 13:58:33 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l55JwVxW008273
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 13:58:31 -0600
In-Reply-To: <1181065603.3839.8.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 05 Jun 2007 10:46:43 -0700
Mingming Cao <cmm@us.ibm.com> wrote:
> The better choice to me is using ext4_blocks_count() to hide the details
> of the little endian. It's fine to use s_blocks_count_hi directly, just
> to make it clear, this is on-disk superblock data and better to do
> little endian conversion like read-in other on-disk superblock fields. 

On the grounds of avoiding confusion regarthing the use of
s_blocks_count_hi, I agree that using ext4_blocks_count() is the right
thing to do.  I will resubmit the patch and also eliminate the the 4
lines of comments since the code would be more explicit as to what its
doing.

> Yeah, it probably unnecessary in this case, but I don't think the extra
> instruction plays an important role in the performance, (this is only
> called at mount time, and there are lots of other places doing little
> endian conversion in ext4_fill_super() anyway).

I originally wrote this patch using ext4_blocks_count() but later
changed it since it was faster to do it this way.  While mounting is
not always a performance critical section, I still see those few extra
instructions a little wasteful. :)


-JRS
