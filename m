From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][PATCH] Set JBD2_FEATURE_INCOMPAT_64BIT on filesystems
	larger than 32-bit blocks (take 2).
Date: Tue, 05 Jun 2007 10:46:43 -0700
Message-ID: <1181065603.3839.8.camel@dyn9047017103.beaverton.ibm.com>
References: <20070601105234.4be40028@rx8>
	 <20070601225441.GF5181@schatzie.adilger.int>	<20070604113210.1a76934b@gara>
	 <20070604175728.GT5181@schatzie.adilger.int>
	 <1180998105.3770.27.camel@dyn9047017103.beaverton.ibm.com>
	 <20070605064109.2cb6bad7@gara>
	 <1181049283.18452.0.camel@kleikamp.austin.ibm.com>
	 <4665649D.8010302@bull.net>	<20070605084937.7622258a@gara>
	 <46656D40.4050505@bull.net> <20070605104657.13d60531@gara>
	 <46658A42.7040105@bull.net>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:34777 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbXFERqs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jun 2007 13:46:48 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l55HkmcK026902
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 13:46:48 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l55HkkSk090038
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 11:46:46 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l55HkjIN006653
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jun 2007 11:46:45 -0600
In-Reply-To: <46658A42.7040105@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-06-05 at 18:07 +0200, Laurent Vivier wrote:
> Jose R. Santos wrote:
> > On Tue, 05 Jun 2007 16:03:44 +0200
> > Laurent Vivier <Laurent.Vivier@bull.net> wrote:
> >> Jose R. Santos wrote:
> >>> Hi Laurent,
> >>>
> >>> In this particular case though, the value of s_blocks_count_hi should not be
> >>> uses on its own.  The correct way would be to use ext4_blocks_count() which
> >>> already does the endian conversion.  If you think the code could confuse
> >>> people as to how to access the data in s_blocks_count_hi, wouldn't hiding it
> >>> through the use of a macro make more sense than doing an unnecessary endian
> >>> conversion?
> >>>
> >> Yes, I think the code could confuse people, but I don't think defining "Yet
> >> Another Macro" is a good choice (IMHO).
> >>
> >> I think we can resolve this (non-)issue by two ways:
> >> - using le32_to_cpu() (but I agree it does an unnecessary endian conversion on
> >> big-endian systems)
> > 
> > I just think that adding extra instructions for the sake of slightly
> > better code readability is wrong, especially when the value
> > s_blocks_count_hi should not be used on its own.
> > 
> >> - put a comment on the line (but are we allowed to put comments in kernel source
> >> code... ;-) )
> > 
> > One advantage of a macro here is that we would make the code more
> > explicit and should be able to eliminate the need for those 4 lines of
> > comments that this patch adds.
> 
> IMHO, you should do as _you_ think it is better... but as Mingming did the first
> comment perhaps she can explain what she thought.
> 

The better choice to me is using ext4_blocks_count() to hide the details
of the little endian. It's fine to use s_blocks_count_hi directly, just
to make it clear, this is on-disk superblock data and better to do
little endian conversion like read-in other on-disk superblock fields. 

Yeah, it probably unnecessary in this case, but I don't think the extra
instruction plays an important role in the performance, (this is only
called at mount time, and there are lots of other places doing little
endian conversion in ext4_fill_super() anyway).

Mingming
> Regards,
> Laurent
