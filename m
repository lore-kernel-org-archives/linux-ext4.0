From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] powerpc: Export needed symbol for ZERO_PAGE usage in
	modules.
Date: Tue, 25 Mar 2008 19:18:18 -0400
Message-ID: <20080325231818.GC25379@mit.edu>
References: <1206381825-12701-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, akpm@linux-foundation.org, paulus@samba.org,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59424 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbYCYXTq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Mar 2008 19:19:46 -0400
Content-Disposition: inline
In-Reply-To: <1206381825-12701-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 24, 2008 at 11:33:45PM +0530, Aneesh Kumar K.V wrote:
> ext4 use ZERO_PAGE(0) to zero out blocks. We need to export
> different symbols in different arch for the usage of ZERO_PAGE
> in modules.

Aneesh, FYI this is already in in powerpc's next branch.

	    	    	       	  	    - Ted
