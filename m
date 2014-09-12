From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/25] misc: zero s_jnl_blocks when removing internal
 journal
Date: Fri, 12 Sep 2014 09:43:42 -0700
Message-ID: <20140912164342.GA10178@birch.djwong.org>
References: <BAY406-EAS308E30D9E82235BD5A84A0EFDCD0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23640 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaILQnr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2014 12:43:47 -0400
Content-Disposition: inline
In-Reply-To: <BAY406-EAS308E30D9E82235BD5A84A0EFDCD0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[cc linux-ext4]

On Fri, Sep 12, 2014 at 10:09:55AM -0400, TR Reardon wrote:
> Note that this only works (zeroes out) when removing inode journal.  Removing
> an existing journal_dev leaves s_jnl_blocks untouched.  To be absolutely
> clean, perhaps it should be wiped in all removal cases?

s_jnl_blocks shouldn't be set if an external journal is in use.

(Unless it is somehow?)

--D

> 
> --- Original Message ---
> 
> From: "Theodore Ts'o" <tytso@mit.edu>
> Sent: September 11, 2014 12:44 PM
> To: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: linux-ext4@vger.kernel.org, "TR Reardon" <thomas_reardon@hotmail.com>
> Subject: Re: [PATCH 09/25] misc: zero s_jnl_blocks when removing internal journal
> 
> On Mon, Sep 08, 2014 at 04:12:35PM -0700, Darrick J. Wong wrote:
> > When we're removing the internal journal (broken journal, turning it
> > off, or adding an external journal), zero s_jnl_blocks so that they
> > can't be picked up by accident later.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Cc: TR Reardon <thomas_reardon@hotmail.com>
> 
> Applied, thanks.
> 
>                                         - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
