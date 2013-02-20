From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] xfstests: add fio requirement V2
Date: Wed, 20 Feb 2013 12:19:21 +1100
Message-ID: <20130220011854.GK10731@dastard>
References: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:20051 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307Ab3BTBTY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2013 20:19:24 -0500
Content-Disposition: inline
In-Reply-To: <1361273843-16094-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 19, 2013 at 03:37:13PM +0400, Dmitry Monakhov wrote:
> FIO is very flexible io generator, I would call it IO swiss knife.
> Currently we have tonns of hardcoded application which reproduces
> some predefined scenario. This approach has obvious dissadvantages
> 1) Lack of flexability: one written it is hard to modify it in future
> 2) Code base is large, many routines written again and again
> 
> At the same time add new fio based tast is just add simle INI file.
> This greatly simplify code review. I do beleve that some day we will
> replace most of hardcoded io binaries with fio.
> 
> One who is planning to run $FIO_PROG should first check that system
> contains appropriate version which is able to handle jobfile
> for example:  _require_fio 286-job.fio
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Hi Dimitry,

Can you rebase this series on top of a current xfstests tree? It
doesn't apply without conflicts or trying to land on top of existing
files, so that makes it hard to actually test and do a final review
on....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
