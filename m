From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Beginner questions about ext4
Date: Wed, 12 Jun 2013 12:20:26 +0000 (UTC)
Message-ID: <loom.20130612T140739-743@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37379 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3FLMUp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 08:20:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Umk2d-0001Ob-FP
	for linux-ext4@vger.kernel.org; Wed, 12 Jun 2013 14:20:43 +0200
Received: from 91.241.2.251 ([91.241.2.251])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jun 2013 14:20:43 +0200
Received: from felipemonteiro.carvalho by 91.241.2.251 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jun 2013 14:20:43 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I am starting with ext4 development, so I have lot's of questions =)

1> About ext4 feature FLEX_BG, I see that it merges multiple
groups in 1 group, but I wonder how this makes sense...
In ext3 did each block group contain always 1 block? 
If not, then how many?
And if not, how does that differ from FLEX_BG?

2> I see that the number of groups inside a flexible group is
given by 2^sb.s_log_groups_per_flex but:
a> Every single group is a flexible group or some are and some now?
b> This number is the same for all flexible groups?

3> Could anyone be kind enough to post the full path which is done
to find data in a given file?
I already found inode.i_block .... wonder what are the other links between 
things, like for example between a group and inodes, etc...

thanks,

Felipe Monteiro de Carvalho

PS: I need to restrict each line to 80 chars because of gmane,
sorry for that =(

