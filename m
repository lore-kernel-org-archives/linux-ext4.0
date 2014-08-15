From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: possible different donor file naming in e4defrag
Date: Fri, 15 Aug 2014 23:04:21 +0200
Message-ID: <4DF4149D-9995-475D-B25E-DAE799DE6100@dilger.ca>
References: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl> <20140815203909.GM2808@birch.djwong.org> <BAY179-W62818B481ECC21D8121A2FFDE90@phx.gbl>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56014 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaHOVEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2014 17:04:25 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so1319312wiv.7
        for <linux-ext4@vger.kernel.org>; Fri, 15 Aug 2014 14:04:24 -0700 (PDT)
In-Reply-To: <BAY179-W62818B481ECC21D8121A2FFDE90@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The reason the donor file is created in the same directory as the source is to try and keep the block allocation policy consistent with the original inode. 

You may not need a SIGINT handler, since the timestamp could be reset as soon as the file is created and unlinked. 

It may also be possible to use O_TMPFILE on newer kernels to create the donor file to avoid any races?

Cheers, Andreas

> On Aug 15, 2014, at 22:45, TR Reardon <thomas_reardon@hotmail.com> wrote:
> 
> 
>>> On Fri, Aug 15, 2014 at 04:12:40PM -0400, TR Reardon wrote:
>>> Currently, e4defrag creates a donor file _in the same directory_ of
>>> the file being defrag'ed.
>>> 
>>> The problem with this is that the containing directory times are
>>> changed because of the transient presence of the donor file. Any
>>> thoughts as to moving the donor to a better location, mount-root, or
>>> /lost+found? Or, ugh, a configurable location, if non-privileged
>>> defrag is important?
>> 
>> How about we just reset the directory time? (Or does utime() not work?)
>> 
>> --D
> 
> Er, yes, that's simpler.  And a SIGINT handler just to keep things tidy?
> 
> +Reardon
> 
>                         --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
