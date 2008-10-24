From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_has_free_blocks always checks cap_sys_resource and makes
 SELinux unhappy
Date: Fri, 24 Oct 2008 14:02:44 -0500
Message-ID: <49021BD4.2040305@redhat.com>
References: <1224860735.3404.74.camel@localhost.localdomain>	 <4901FE29.3090600@redhat.com> <1224874836.6379.3.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Eric Paris <eparis@redhat.com>, linux-ext4@vger.kernel.org,
	selinux@tycho.nsa.gov, sds@tycho.nsa.gov, esandeen@redhat.com,
	tytso@mit.edu, dwalsh@redhat.com,
	linux-security-module@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32931 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYJXTDP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Oct 2008 15:03:15 -0400
In-Reply-To: <1224874836.6379.3.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming Cao wrote:

> Most functionality in ext4_has_free_blocks()  is duplicated in
> ext4_claim_free_blocks(). I guess the ext4_has_free_blocks() could be
> simplified a bit, or the two functional merge into one.
> 
> The delay cap check sounds right thing to me.

good point on the duplication, I'll merge them as part of this.

Thanks Mingming,
-Eric
