From: Andrew Morton <akpm@osdl.org>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 5 Oct 2006 17:39:33 -0700
Message-ID: <20061005173933.f54555fb.akpm@osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:37852 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932496AbWJFAjg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2006 20:39:36 -0400
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 05 Oct 2006 13:23:30 -0500
Dave Kleikamp <shaggy@austin.ibm.com> wrote:

> I have rebuilt the ext4/jbd2 patches against linux-2.6.19-rc1.  The
> patch set is located at
> ftp://kernel.org/pub/linux/kernel/people/shaggy/ext4/2.6.19-rc1/ext4-patches-2.6.19-rc1.tar.gz
> 
> Broken out patches in
> ftp://kernel.org/pub/linux/kernel/people/shaggy/ext4/2.6.19-rc1/ext4-patches
> 
> The patches begin with exact copies of the rc1 version of ext3 and jbd,
> so there are no ext3/jbd patches currently in mainline that need to be
> applied to the new code.  I'll continue to watch ext3/jbd for patches
> that need to be ported to ext4/jbd2.

Could we please have a few nice words about ext4 for the record?  Like,
what its features are, how one creates an instance, where to get the
correct userspace tools from, stability level, any known shortcomings,
issues, etc?

Thanks.
