From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC 1/4] Large Blocksize support for Ext2/3/4
Date: Fri, 31 Aug 2007 17:01:30 -0700
Message-ID: <1188604890.3837.38.camel@localhost.localdomain>
References: <20070828190551.415127746@sgi.com>
	 <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, adilger@clusterfs.com,
	sho@tnes.nec.co.jp, ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: clameter@sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59393 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbXIAABQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Aug 2007 20:01:16 -0400
In-Reply-To: <1188434857.3799.76.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-08-29 at 17:47 -0700, Mingming Cao wrote:

> Just rebase to 2.6.23-rc4 and against the ext4 patch queue. Compile tested only. 
> 
> Next steps:
> Need a e2fsprogs changes to able test this feature. As mkfs needs to be
> educated not assuming rec_len to be blocksize all the time.
> Will try it with Christoph Lameter's large block patch next.
> 

Two problems were found when testing largeblock on ext3.  Patches to
follow. 

Good news is, with your changes, plus all these extN changes, I am able
to run ext2/3/4 with 64k block size, tested on x86 and ppc64 with 4k
page size. fsx test runs fine for an hour on ext3 with 16k blocksize on
x86:-)

Mingming
