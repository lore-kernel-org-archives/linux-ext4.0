From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: What is status of metadata_csum
Date: Fri, 17 Jan 2014 10:54:46 -0800
Message-ID: <20140117185446.GB3897@birch.djwong.org>
References: <52D7BB10.5090003@rempel-privat.de>
 <20140117020009.GL9229@birch.djwong.org>
 <52D8E755.6030205@rempel-privat.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Oleksij Rempel <linux@rempel-privat.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45063 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaAQSyx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jan 2014 13:54:53 -0500
Content-Disposition: inline
In-Reply-To: <52D8E755.6030205@rempel-privat.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 17, 2014 at 09:18:29AM +0100, Oleksij Rempel wrote:
> Am 17.01.2014 03:00, schrieb Darrick J. Wong:
> > On Thu, Jan 16, 2014 at 11:57:20AM +0100, Oleksij Rempel wrote:
> >> What is metadata_csum status?
> >>
> >> i see there are benchmark updates on wiki page, but no updates for
> >> e2fsprogs. 1.43-WIP seems to be really old.
> > 
> > Still waiting for 1.43.  I don't know if there are early adopters running
> > 1.43-WIP without complaint, or if simply nobody's using it at all. :/
> 
> I didn't tested current master.git - my bad. It is not outdated :)
> 
> Beside, the wiki should be corrected. If you enable 64bit, it will need
> extents too.

I updated the howto.  mke2fs (as of 1.42.9) should no longer allow
extents,64bit on a filesystem.

--D
> 
> Are there any existing tools for error injection for file systems?
> Random read error from libata or silent data corruptions?
> -- 
> Regards,
> Oleksij
> 


