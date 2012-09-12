From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ongoing data reorganization/defragmentation?
Date: Wed, 12 Sep 2012 11:35:53 -0600
Message-ID: <080474D2-A9F0-42F2-A114-82766127B7BC@dilger.ca>
References: <5050BA08.80709@bytefortress.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "norritt@t-online.de" <norritt@t-online.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail129c7-2520.megamailservers.com ([69.49.98.24]:52898 "EHLO
	mail129c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754954Ab2ILRf6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2012 13:35:58 -0400
In-Reply-To: <5050BA08.80709@bytefortress.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-09-12, at 10:36, norritt@t-online.de wrote:

> Ongoing data reorganization/defragmentation?
> 
> I also know from the ext4 dcumentation, that ext4 is written to support online defragmentation. I've read several rumours on forums and blogs that indicate ext4 is doing some kind of "ongoing data reorganisations or defragmentation" in the background, in case the mechanisms to prevent fragmentation in the first place failed for some reason (i.e. when a fs is running out of free space). I did not find any credible information to back up these claims, that ext4 is actively reorganizing data, but I didn't find any information that prove these claims wrong either.
> 
> So my question is, does ext4 reorganize data when it encounters fragmented files? If so, is there a way to disable that feature which would not do any good on SSDs? Is there anything else to consider when using ext4 on SSDs, except the things I mentioned above?

No, there is no such background reorganization happening of allocated files. With "delalloc" there is batching of block allocations to try and optimize the initial block selection, but it is static after this time. 

Cheers, Andreas