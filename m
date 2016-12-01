From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 5/6] dax: Call ->iomap_begin without entry lock during
 dax fault
Date: Thu, 1 Dec 2016 15:24:47 -0700
Message-ID: <20161201222447.GB13739@linux.intel.com>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
 <1479980796-26161-6-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org,
        linux-nvdimm@lists.01.org, Johannes Weiner <hannes@cmpxchg.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:6627 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932182AbcLAWYt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Dec 2016 17:24:49 -0500
Content-Disposition: inline
In-Reply-To: <1479980796-26161-6-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 24, 2016 at 10:46:35AM +0100, Jan Kara wrote:
> Currently ->iomap_begin() handler is called with entry lock held. If the
> filesystem held any locks between ->iomap_begin() and ->iomap_end()
> (such as ext4 which will want to hold transaction open), this would cause
> lock inversion with the iomap_apply() from standard IO path which first
> calls ->iomap_begin() and only then calls ->actor() callback which grabs
> entry locks for DAX.

I don't see the dax_iomap_actor() grabbing any entry locks for DAX?  Is this
an issue currently, or are you just trying to make the code consistent so we
don't run into issues in the future?
