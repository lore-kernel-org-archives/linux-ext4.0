From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: delayed allocation i_blocks fix for stat(2)
Date: Mon, 7 Jul 2008 19:47:45 -0400
Message-ID: <20080707234745.GG31490@mit.edu>
References: <1215473799.6702.9.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52471 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbYGGXsY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jul 2008 19:48:24 -0400
Content-Disposition: inline
In-Reply-To: <1215473799.6702.9.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 07, 2008 at 04:36:39PM -0700, Mingming Cao wrote:
> ext4: delayed allocation i_blocks fix for stat(2)

Looks good, thanks!!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I'm going to do a quick test and probably push out a 2.6.26-rc9-ext4-1
snapshot later this evening.

						- Ted
