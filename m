From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Mon, 23 Sep 2013 09:35:05 -0600
Message-ID: <52405FA9.1010701@hp.com>
References: <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz> <5230D739.9010109@redhat.com> <20130911212523.GE13397@thunk.org> <5230D450.7000609@hp.com> <20130912122317.GC12918@thunk.org> <5232FF3E.7080604@hp.com> <5233609F.7060303@redhat.com> <523886CE.2070203@hp.com> <5239B65E.4060202@redhat.com> <20130921185304.GB8606@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	T Makphaibulchoke <tmac@hp.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	aswin@hp.com, aswin_proj@lists.hp.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:27188 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3IWVi3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Sep 2013 17:38:29 -0400
In-Reply-To: <20130921185304.GB8606@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/21/2013 12:53 PM, Theodore Ts'o wrote:

> 
> Mak, did you mean a ext4 file system created on a ramdisk, using a
> /dev/ramNN device, or the literal "ramfs" file system?
> 
> I assume the former, right?
> 
> 					- Ted
> 

Yes Ted, that is correct, the filesystem using /dev/ramNN.

Thanks,
Mak.

