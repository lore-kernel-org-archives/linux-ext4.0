From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Fw: [BUG -mm] ext3_orphan_add() accessing corrupted list on a corrupted ext3fs
Date: Thu, 01 Feb 2007 20:28:21 +0300
Message-ID: <m3odod4wju.fsf@bzzz.home.net>
References: <20070201010836.31a63ef2.akpm@osdl.org>
	<20070201102534.GF5404@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Fengguang Wu <fengguang.wu@gmail.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe01.tochka.ru ([62.5.255.21]:63400 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751823AbXBAR2a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Feb 2007 12:28:30 -0500
In-Reply-To: <20070201102534.GF5404@schatzie.adilger.int> (Andreas Dilger's
	message of "Thu\, 1 Feb 2007 03\:25\:34 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Andreas Dilger (AD) writes:

 AD> I don't have a comment on the actual bug here, but this is another case
 AD> where it would be nice to have multi-mount protection built into ext3...
 AD> When I last proposed this it was refused on the grounds that an external
 AD> HA manager should be doing this job but I don't think that is realistic.

can we use JBD-like approach? export some inode and MMP/whatever
would 'ping' 1st block of the inode.

thanks, Alex
