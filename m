From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
Date: Sun, 09 Feb 2014 12:46:41 -0700
Message-ID: <52F7DB21.2050204@hp.com>
References: <1377186876-57291-1-git-send-email-tmac@hp.com> <1390588288-66930-1-git-send-email-tmac@hp.com> <87fvodcb65.fsf@tassilo.jf.intel.com> <DBA818DD-1C87-4B98-8475-8BB8F00F7DA4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: T Makphaibulchoke <tmac@hp.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"aswin@hp.com" <aswin@hp.com>
To: Andreas Dilger <adilger@dilger.ca>,
	Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6830 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaBJBzp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Feb 2014 20:55:45 -0500
In-Reply-To: <DBA818DD-1C87-4B98-8475-8BB8F00F7DA4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/24/2014 11:09 PM, Andreas Dilger wrote:
> I think the ext4 block groups are locked with the blockgroup_lock that has about the same number of locks as the number of cores, with a max of 128, IIRC.  See blockgroup_lock.h. 
> 
> While there is some chance of contention, it is also unlikely that all of the cores are locking this area at the same time.  
> 
> Cheers, Andreas
> 



