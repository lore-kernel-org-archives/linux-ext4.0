From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Test results for ext4
Date: Sat, 31 May 2008 14:35:13 -0500
Message-ID: <4841A871.3020500@redhat.com>
References: <48402253.8040407@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	"Jose R. Santos" <jrs@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbYEaThK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 May 2008 15:37:10 -0400
In-Reply-To: <48402253.8040407@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Clement wrote:
> Hi all,
> 
> Since a couple of weeks, I did batches of tests to have some performance
> numbers for the new ext4 features like uninit_groups, flex_bg or
> journal_checksum on a 5TB filesystem.
> I tried to test allmost all combinations of mkfs and mount options, but
> I put only a subset of them in the result tables, the most significant
> for me.
> 
> I had started to do these tests on a kernel 2.6.26-rc1, but I'd got several
> hangs and crashes occuring randomly outside ext4, sometimes in the slab
> code or in the scsi driver eg., and which were not reproductible.
> Since 2.6.26-rc2, no crash or hang occur with ext4 on my system.
> 
> The first results and the test description are available here:
> http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.html
> http://www.bullopensource.org/ext4/20080530/ffsb-readwrite-2.6.26-rc2.html
> 

One other question on the tests; am I reading correctly that ext3 used
"data=writeback" but ext4 used the default data=ordered mode?

Thanks,
-Eric
