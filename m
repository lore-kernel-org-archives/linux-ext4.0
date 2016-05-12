From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] dax: Fix condition for filling of PMD holes
Date: Thu, 12 May 2016 13:03:04 -0600
Message-ID: <20160512190304.GB32376@linux.intel.com>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
 <1463070560-1979-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nvdimm@lists.01.org, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6108 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbcELTDQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 May 2016 15:03:16 -0400
Content-Disposition: inline
In-Reply-To: <1463070560-1979-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 12, 2016 at 06:29:14PM +0200, Jan Kara wrote:
> Currently dax_pmd_fault() decides to fill a PMD-sized hole only if
> returned buffer has BH_Uptodate set. However that doesn't get set for
> any mapping buffer so that branch is actually a dead code. The
> BH_Uptodate check doesn't make any sense so just remove it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

With the note that when we reenable PMD faults we need to either test this
huge zero page path or just get rid of it and fall back to 4k zero pages.
