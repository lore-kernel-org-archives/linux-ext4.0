From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: possible different donor file naming in e4defrag
Date: Fri, 15 Aug 2014 13:39:09 -0700
Message-ID: <20140815203909.GM2808@birch.djwong.org>
References: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21795 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaHOUjO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2014 16:39:14 -0400
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2014 at 04:12:40PM -0400, TR Reardon wrote:
> Currently, e4defrag creates a donor file _in the same directory_ of
> the file being defrag'ed.
> 
> The problem with this is that the containing directory times are
> changed because of the transient presence of the donor file.  Any
> thoughts as to moving the donor to a better location, mount-root, or
> /lost+found?  Or, ugh, a configurable location, if non-privileged
> defrag is important?

How about we just reset the directory time?  (Or does utime() not work?)

--D
> 
> +Reardon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
