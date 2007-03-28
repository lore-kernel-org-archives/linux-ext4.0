From: Jan Kara <jack@ucw.cz>
Subject: Re: ext2/ext3 still under active maintenance?
Date: Wed, 28 Mar 2007 14:30:27 +0200
Message-ID: <20070328123027.GF14935@atrey.karlin.mff.cuni.cz>
References: <alpine.DEB.0.83.0703270845550.23055@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37755 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbXC1Ma2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Mar 2007 08:30:28 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.83.0703270845550.23055@sigma.j-a-k-j.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

> I'm trying to look at the ext2/ext3 source for learning Linux FS 
> development. I'm avoiding ext4 for now because it's under active 
> development and it's too much to chew before I understand the previous 
> versions. But am I going to get an outdated view of the right way to 
> program filesystems if I look at those, or is the code just as shiny as 
> ext4's?
  Definitely you won't get an outdated view of how a filesystem is written.
ext4 uses ext3 code as its baseline and although there are new features
flowing in, the basic things stay the same.

								Honza
