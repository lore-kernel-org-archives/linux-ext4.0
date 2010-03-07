From: tytso@mit.edu
Subject: Re: [PATCH 27/28] ext4: Convert BUG_ON checks to use ext4_error()
 instead
Date: Sat, 6 Mar 2010 21:45:31 -0500
Message-ID: <20100307024531.GB5395@thunk.org>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
 <1267553925-6308-28-git-send-email-tytso@mit.edu>
 <87r5nxsitn.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Frank Mayhar <fmayhar@google.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:32908 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0CGCpf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Mar 2010 21:45:35 -0500
Content-Disposition: inline
In-Reply-To: <87r5nxsitn.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 06, 2010 at 06:33:48PM +0530, Aneesh Kumar K. V wrote:
> 
> I guess ext4_error and ext4_warning are now not taking __func__. So we
> to be consistant with thos i this this can be in lower case even though
> they are #defines.

Or maybe we should rename them be EXT4_ERROR and EXT4_WARNING.  What
do other people think?

						- Ted
