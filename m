From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: Remove unneeded code.
Date: Sat, 22 Nov 2008 14:08:05 -0500
Message-ID: <20081122190805.GD9150@mit.edu>
References: <1227007527-4732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60488 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758112AbYKVXBb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Nov 2008 18:01:31 -0500
Content-Disposition: inline
In-Reply-To: <1227007527-4732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 18, 2008 at 04:55:27PM +0530, Aneesh Kumar K.V wrote:
> This also caused an ext4_error when mounting a file system
> with only one block group.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

thanks, applied (with a slightly different patch description).

		      		 	   	 - Ted
