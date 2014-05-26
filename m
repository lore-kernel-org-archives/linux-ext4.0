From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: ext4 metadata corruption bug?
Date: Mon, 26 May 2014 16:59:24 +0200
Message-ID: <20140526145924.GF16233@dot.freshdot.net>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
 <20140423072311.GD10163@dot.freshdot.net>
 <20140423143642.GA29925@thunk.org>
 <20140501170226.GF26929@dot.freshdot.net>
 <20140506142228.GA15137@dot.freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dot.freshdot.net ([213.154.236.176]:45327 "EHLO
	dot.freshdot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaEZPmf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2014 11:42:35 -0400
Content-Disposition: inline
In-Reply-To: <20140506142228.GA15137@dot.freshdot.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quoting Sander Smeenk (ssmeenk@freshdot.net):

> > > Finally, since the both of you are seeing these messages fairly
> > > frequently, would you be willing to run with a patched kernel?
> > JFYI, i am running the patched kernel but i havent had any 'luck' yet.
> FWIW, the VM crashed this morning.
> Alas, nothing was logged or visible on the console. :(

'Crashed' today, but no traces were produced because aparently xfs and
btrfs (both aren't even used) modules have 'bad taint':

| xfs: module has bad taint, not creating trace events
| btrfs: module has bad taint, not creating trace events
| EXT4-fs error (device vda1): ext4_mb_generate_buddy:756: group 75, 11202 clusters in bitmap, 11200 in gd; block bitmap corrupt. 
| Aborting journal on device vda1-8.
| EXT4-fs (vda1): Remounting filesystem read-only

Also, this is vda1, not vdb. vda1 is my root fs and is only 10GB in
size.

-- 
| Bakers trade bread recipes on a knead to know basis.  
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
