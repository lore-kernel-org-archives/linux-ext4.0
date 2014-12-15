From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 35/47] resize2fs: convert fs to and from 64bit mode
Date: Sun, 14 Dec 2014 22:41:24 -0800
Message-ID: <20141215064124.GC5368@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215433.883.51160.stgit@birch.djwong.org>
 <20141215033212.GG17575@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31801 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaLOGlc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Dec 2014 01:41:32 -0500
Content-Disposition: inline
In-Reply-To: <20141215033212.GG17575@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 14, 2014 at 10:32:12PM -0500, Theodore Ts'o wrote:
> On Fri, Nov 07, 2014 at 01:54:33PM -0800, Darrick J. Wong wrote:
> > +		case 'b':
> > +			flags |= RESIZE_ENABLE_64BIT;
> > +			break;
> > +		case 's':
> > +			flags |= RESIZE_DISABLE_64BIT;
> > +			break;
> 
> Out of curiosity, how did you come up with the options -b and -s?
> "big" and "small"?
> 
> It's not necessarily the most mnemonic, but I can't come up with
> anything better, myself.

Yep.  It's also tempting to fix up tune2fs to detect "-O 64bit" and
call out to resize2fs, but that's another discussion.

--D

> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
