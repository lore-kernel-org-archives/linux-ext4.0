From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RESEND] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Thu, 14 Feb 2008 10:38:09 -0600
Message-ID: <47B46E71.805@redhat.com>
References: <1203006909.8970.20.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbYBNQjP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2008 11:39:15 -0500
In-Reply-To: <1203006909.8970.20.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Clement wrote:
> Fix kernel BUG at fs/ext4/mballoc.c:910!
> 
> From: Valerie Clement <valerie.clement@bull.net>
> 
> With the flex_bg feature enabled, a large file creation oopses the
> kernel.

Valerie, what's the specific testcase for this?

Thanks,
-Eric
