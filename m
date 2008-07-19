From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs: Fix tst_extents output on bigendian machine.
Date: Fri, 18 Jul 2008 21:19:21 -0400
Message-ID: <20080719011921.GB18506@mit.edu>
References: <1216382740-24369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:50599 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbYGSDX5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 23:23:57 -0400
Content-Disposition: inline
In-Reply-To: <1216382740-24369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2008 at 05:35:40PM +0530, Aneesh Kumar K.V wrote:
> Add type __le16, __le32, and __le64 to indicate that
> the variables need to be byteswaped when using.

I took out the __le16 types.  The artificial types don't really buy us
much (a lot of work would be needed before we could use sparse on
e2fsprogs) and for now just makes it harder to read the header file.
I removed the __le types deliberately.

I've applied the header printing portion of the patch.

     	     	 		 	    - Ted

