From: Jan Kara <jack@suse.cz>
Subject: Re: barriers off by default?
Date: Thu, 15 May 2008 16:43:55 +0200
Message-ID: <20080515144355.GB19325@atrey.karlin.mff.cuni.cz>
References: <482868A5.1000102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58992 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbYEOOn4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 May 2008 10:43:56 -0400
Content-Disposition: inline
In-Reply-To: <482868A5.1000102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> As I look at my shiny new 500G disks with 32MB of cache, I find myself
> wondering why the default for ext3 and ext4 is to have barriers disabled.
> 
> This is a pretty dangerous default w.r.t. filesystem integrity on power
> loss, no?
  JFYI: SUSE kernel carries for ages a patch which changes this default.
I'd be more than happy to drop it ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
