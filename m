From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [RFC] Block reservation for ext3 (continued)
Date: Tue, 19 Oct 2010 15:58:04 +0000 (UTC)
Message-ID: <loom.20101019T174204-233@post.gmane.org>
References: <20101018221624.GA30303@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41620 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab0JSQFK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Oct 2010 12:05:10 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1P8EgT-0002SY-Au
	for linux-ext4@vger.kernel.org; Tue, 19 Oct 2010 18:05:06 +0200
Received: from 211.201.183.198 ([211.201.183.198])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 19 Oct 2010 18:05:05 +0200
Received: from namhyung by 211.201.183.198 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 19 Oct 2010 18:05:05 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack <at> suse.cz> writes:
> Now I'd like to get to some agreement what we should do. Bite the bullet
> and use (a), or should I continue improving (c)? Or is (b) considered a
> better alternative (we would only need to track reserved data blocks and
> use page dirty tag to detect whether indirect block has some (possibly)
> delayed write pending and thus should be preserved even though there are
> no blocks allocated under it during truncate)? Or something totally
> different?
> 
> 								Honza

Hello,

I'm saying with my *very* limited knowledge. Please don't hurt me so hard
even if it's totally crappy. ;-)

How about having a dedicated thread or something for the allocation? When
page fault occurs we can wake it up with sufficient information and let
it start to do the work on behalf of the user. Doesn't it make any sense?

Thanks.

-- 
Regards,
Namhyung Kim


