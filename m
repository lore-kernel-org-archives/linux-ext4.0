From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Beginner questions about ext4
Date: Sun, 23 Jun 2013 06:29:18 +0000 (UTC)
Message-ID: <loom.20130623T082353-563@post.gmane.org>
References: <loom.20130612T140739-743@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47726 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3FWG3f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Jun 2013 02:29:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Uqdnq-0008NS-Bc
	for linux-ext4@vger.kernel.org; Sun, 23 Jun 2013 08:29:34 +0200
Received: from user-164-127-35-163.play-internet.pl ([164.127.35.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 23 Jun 2013 08:29:34 +0200
Received: from felipemonteiro.carvalho by user-164-127-35-163.play-internet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sun, 23 Jun 2013 08:29:34 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I can now already answer some of my questions, thought others not:

> In ext3 did each block group contain always 1 block? 
> If not, then how many?

This information is in ext4_super_block.s_blocks_per_group

> 2> I see that the number of groups inside a flexible group is
> given by 2^sb.s_log_groups_per_flex but:
> a> Every single group is a flexible group or some are and some now?

I am still very much interesting in knowing this! Are all groups flexible 
groups when FLEX_BG feature is activated?

I found this image for how things relate to one another without flex_bg:

http://origin-ars.els-cdn.com/content/image/1-s2.0-S1742287612000357-gr1.jpg

Does anyone know if there is a simular image with flex_bg???

thanks,

Felipe Monteiro de Carvalho


