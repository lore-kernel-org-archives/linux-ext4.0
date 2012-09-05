From: darxus@chaosreigns.com
Subject: Re: Weird filesystem corruption from wayland / radeon / chromium
Date: Tue, 4 Sep 2012 23:38:18 -0400
Message-ID: <20120905033818.GL19158@chaosreigns.com>
References: <20120903220213.GE19158@chaosreigns.com>
 <20120904032919.GJ5066@thunk.org>
 <20120905024848.GK19158@chaosreigns.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from panic.chaosreigns.com ([64.71.152.40]:44015 "EHLO
	panic.chaosreigns.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab2IEDiS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 23:38:18 -0400
Content-Disposition: inline
In-Reply-To: <20120905024848.GK19158@chaosreigns.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FYI, after fsck'ing, I checked my filesystem against my backup, and didn't
find anything that changed that shouldn't have changed.  Command I used
was:

rsync -imva --compare-dest=/ /media/4tb/bak/dancer-2012-09-04/ /media/4tb/bak/changes/

-- 
"Just because you're offended, doesn't mean you're right." - Ricky Gervais
http://www.ChaosReigns.com
