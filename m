From: Jan Kara <jack@suse.cz>
Subject: Re: which IO-scheduler is best for flash based storage device with
 ext4
Date: Wed, 13 Jan 2016 10:06:08 +0100
Message-ID: <20160113090608.GB14630@quack.suse.cz>
References: <a6b26fd61d88475784c7745b92fe0ae2@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbcAMJGC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jan 2016 04:06:02 -0500
Content-Disposition: inline
In-Reply-To: <a6b26fd61d88475784c7745b92fe0ae2@SGPMBX1004.APAC.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Wed 13-01-16 06:33:28, HUANG Weller (CM/ESW12-CN) wrote:
> Could you tell me which  IO-scheduler is best for flash based storage
> device with ext4 ?  Just search from WWW, I saw it is said that the noop
> is best because the CFQ is design for the mechanical hard disk.  And I
> did the performance test with IOzone between the IO-scheduler noop and
> cfq. The performance difference is small.  So here I want to get some
> answer from you about this question.

Yes, CFQ is meant for classical rotational disk. For normal SSDs I use
deadline IO scheduler (it does more request merging, prefers read over
writes), for high-end I'd use noop.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
