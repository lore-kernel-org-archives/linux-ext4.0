From: Mark Nelson <markn@au1.ibm.com>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Wed, 25 Feb 2009 23:13:40 +1100
Message-ID: <200902252313.40670.markn@au1.ibm.com>
References: <49A2705D.9030008@in.ibm.com> <200902251752.56514.markn@au1.ibm.com> <49A526A6.70509@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	linuxppc-dev@ozlabs.org, Jan Kara <jack@suse.cz>,
	Jan Kara <jack@ucw.cz>, Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, benh@kernel.crashing.org
To: "Sachin P. Sant" <sachinp@in.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42415 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZBYMMS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 07:12:18 -0500
In-Reply-To: <49A526A6.70509@in.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 25 Feb 2009 10:08:22 pm Sachin P. Sant wrote:
> Mark Nelson wrote:
> > Hi Sanchin and Geert,
> >
> > Does the patch below fix the problems you're seeing? If it does I'll send
> > a properly written up and formatted patch to linuxppc-dev (as well as
> > another one to fix the same problem in copy_tofrom_user()).
> >   
> This patch fixes the issue at my side. I tried booting the system few times
> and every single time it came up clean.

Good to hear. Thanks for testing Sanchin!

Mark
