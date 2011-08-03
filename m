From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fsck.ext4 multiply-claimed blocks
Date: Wed, 3 Aug 2011 10:02:26 -0600
Message-ID: <1EC3A2BF-642E-4B4C-9D98-F3032AB0B572@dilger.ca>
References: <20110803091053.316860@gmx.net>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: markus hansen <hansenmarkus@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from to5email.gprs.rogers.com ([74.198.8.2]:56787 "EHLO
	to5email2.gprs.rogers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1HCQJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2011 12:09:04 -0400
In-Reply-To: <20110803091053.316860@gmx.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-03, at 3:10 AM, "markus hansen" <hansenmarkus@gmx.de> wrote:
> I have a huge crashed ext4 filesystem with lots of Hardlinks in it. fsck.ext4 has not completed after 24h, handling "multiply-claimed blocks" eats the time. Stupid beginner question: Are the offered two Options (a) "copy multiply claimed blocks" (b) "delete inodes" useful in case multiple hardlinks point to same blocks? Isnt it ok in that case, that blocks are multiply claimed?

Multiply claimed blocks means they are claimed by multiple different inodes, and is unrelated to hard links. 

Cheers, Andreas