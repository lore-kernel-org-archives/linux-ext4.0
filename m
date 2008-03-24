From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Mon, 24 Mar 2008 10:00:42 -0500
Message-ID: <47E7C21A.10208@redhat.com>
References: <200803141202.AA00330@TNESG9526.rs.jp.nec.com> <20080314125848.GE3542@webber.adilger.int> <47DE0F8D.2060106@rs.jp.nec.com> <20080317170846.GE3542@webber.adilger.int> <47E789E6.6000806@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, cmm@us.ibm.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760990AbYCXPCO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 11:02:14 -0400
In-Reply-To: <47E789E6.6000806@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Akira Fujita wrote:

> Is EXT4_IOC_FIEMAP going to be added to the ext4 patch queue?
> I will try to use EXT4_IOC_FIEMAP instead of EXT4_IOC_EXTENTS_INFO
> in ext4 online defrag when kernel supports it.

It's not, yet, but I could probably put it there.

It is not ready for upstream yet at all, but it does have a good amount
of functionality.

I'll try to get something submitted for the patch queue soon...

(I decided to slow down a bit on the fiemap work, and concentrate on
helping to get e2fsprogs ready with ext4 support)

-Eric
