From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 tree backports for 2.6.27.19 and 2.6.28.7
Date: Tue, 24 Feb 2009 16:10:57 -0500
Message-ID: <20090224211057.GB7064@mit.edu>
References: <20090224154538.6f57094a@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44108 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbZBXVLA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 16:11:00 -0500
Content-Disposition: inline
In-Reply-To: <20090224154538.6f57094a@dhcp-100-2-144.bos.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 03:45:38PM -0500, Chuck Ebbert wrote:
> In the 2.6.27 series, commit 19815ad26f2d60e3ce390fca4d18ad729c9f5f42
> has an extra chunk. I applied this patch after the series to fix it:

Thanks for spotting this.  I'll submit an update to the stable kernel
series submission.

       	   	    	    	 	   	  - Ted
