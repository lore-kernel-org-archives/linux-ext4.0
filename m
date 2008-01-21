From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: Fix the BUG_ON in jbd2_journal_commit_transaction
Date: Mon, 21 Jan 2008 10:46:56 -0500
Message-ID: <20080121154656.GB29792@mit.edu>
References: <1200894966-10130-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51572 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbYAUPrg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2008 10:47:36 -0500
Content-Disposition: inline
In-Reply-To: <1200894966-10130-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 21, 2008 at 11:26:06AM +0530, Aneesh Kumar K.V wrote:
> kunmap_atomic was passed the wrong argument.

Thanks for pointing this out!  I've applied your fix to
jbd2-journal-chksum.patch in the ext4 patch queue.

			     	      	    - Ted
