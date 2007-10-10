From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: max file size for ext3
Date: Wed, 10 Oct 2007 08:00:46 -0500
Message-ID: <470CCCFE.5000508@redhat.com>
References: <470C64BF.509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbXJJNBA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Oct 2007 09:01:00 -0400
In-Reply-To: <470C64BF.509@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:

> I also think hardcoding 4k block size is not correct. I have the below
> patch pending with large file size.

Sounds much better to me.  I think it also needs to be limited so that
it doesn't exceed what the pagecache can address, i.e. 2^32 * PAGE_SIZE
- this will especially come into play w/ the large blocks, right?

-Eric
