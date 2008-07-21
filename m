From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Crash and stack trace for jbd2 under ext4
Date: Mon, 21 Jul 2008 13:50:10 +0530
Message-ID: <20080721082010.GC8788@skywalker>
References: <48841077.500@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:46905 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbYGUIVi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 04:21:38 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6L8KZFY014190
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 18:20:35 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6L8KLbo4554828
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 18:20:21 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6L8KKTI011504
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 18:20:21 +1000
Content-Disposition: inline
In-Reply-To: <48841077.500@cse.unsw.edu.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 21, 2008 at 02:28:39PM +1000, Shehjar Tikoo wrote:
> Hi all
>
> Please see the contents of the file
> for details of two similar crashes observed
> on two different commits. Both crashes were
> observed while using ext4 on the server while
> accessing the export through NFSv3. The link
> has more details.
>
> http://www.gelato.unsw.edu.au/~shehjart/docs/jbd_ext4_crash.txt
>

I guess we cannot use
#define EXT4_MAX_WRITEBACK_CREDITS    DIO_CREDITS

We do multiple block allocation in ext4_da_writepages and we can 
get these blocks from different block groups. So we may need to update
bitmap of multiple groups.

-aneesh
