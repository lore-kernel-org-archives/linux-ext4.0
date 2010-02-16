From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] do you want jbd2 interface of ext3?
Date: Tue, 16 Feb 2010 19:54:52 +0100
Message-ID: <20100216185452.GE3153@quack.suse.cz>
References: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, adilger@sun.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514Ab0BPSyo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2010 13:54:44 -0500
Content-Disposition: inline
In-Reply-To: <20100216164123.b10b00e5.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Tue 16-02-10 16:41:23, Toshiyuki Okajima wrote:
> I will try to change the journaling interface of ext3 from jbd into jbd2.
> 
> jbd2 has new features from jbd. For example, it includes the integrity 
> improvement features. The body of ext3 is already enough quality. If ext3 
> changes the journaling interface from jbd into jbd2, ext3 filesystem with jbd2
> interface may get better integrity than with the jbd interface.
> (jbd2 is aggressively being developed now, so I think we are glad if we can 
> get the effect of the development of jbd2 for ext3.)
> 
> And ext3 is as de facto standard filesystem, so jbd2 component will be used 
> by more people than now if ext3 has the jbd2 interface. If many people used 
> the jbd2 interface of ext3, the jbd2 component would get more chances to 
> improve the quality and performance and so on. 
> 
> Besides, ext3 is now the only user of jbd. 
> (ocfs2 which was the user of jbd is now the user of jbd2.)
> 
> Do you want the jbd2 interface of ext3?
> If you want the jbd2 interface, I will try to implement one.
  Yes, as Ted pointed out, the main reason why we have a separate codebase for
ext3 and ext4 and similarly jbd and jbd2 is that we didn't want the changes
in ext4/jbd2 to influence (and possibly destabilize) ext3 filesystem. So
switching ext3 to jbd2 would be directly against this logic...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
