From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Mon, 25 Jul 2016 21:55:06 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.12.1607252154570.8973@trent.utfs.org>
References: <20160718105707.GA4253@sig21.net> <20160718133843.GA26664@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Johannes Stezenbach <js@sig21.net>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:34020 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbcGZFFH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2016 01:05:07 -0400
In-Reply-To: <20160718133843.GA26664@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 18 Jul 2016, Theodore Ts'o wrote:
> system corruption detected earlier.  The problem is people
> unfortunately run with their file systems set to errors=continue,

The first thing I do after creating an ext4 fs is to set this to 
errors=remount-ro :-)

Isn't "remount-ro" was XFS is doing when it detects an error? Are
there plans to switch the default for ext4 to that? I never understood why 
errors=continue was the default, thanks for explaining that.

Christian.
-- 
BOFH excuse #339:

manager in the cable duct
