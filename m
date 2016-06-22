From: Jan Kara <jack@suse.cz>
Subject: Re: FW: ext4 out of order when use cfq scheduler
Date: Wed, 22 Jun 2016 15:09:23 +0200
Message-ID: <20160622130923.GD16492@quack2.suse.cz>
References: <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz>
 <20160313042723.GC29218@thunk.org>
 <20160314073928.GD5213@quack.suse.cz>
 <20160314143635.GM29218@thunk.org>
 <20160315104634.GG17942@quack.suse.cz>
 <20160315144633.GA12352@quack.suse.cz>
 <20160315200951.GA1445@quack.suse.cz>
 <f0a9a62a43c4419687c69fff15a7c043@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbcFVNJ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jun 2016 09:09:26 -0400
Content-Disposition: inline
In-Reply-To: <f0a9a62a43c4419687c69fff15a7c043@SGPMBX1004.APAC.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Wed 22-06-16 11:55:12, HUANG Weller (CM/ESW12-CN) wrote:
> I saw the patch " fix data exposure after a crash " in the kernel 4.6.2
> release.  I remember you provided 2 more patches for performance
> optimization. Could you tell me whether they are necessary ?

They are not necessary. They may just improve performance in some cases...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
