From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: df command on EXT4 and XFS filesystem
Date: Thu, 07 Feb 2013 10:51:30 -0600
Message-ID: <5113DB92.6050406@redhat.com>
References: <60A0C755EDF2954AA9C18966C50DB31429E2A0A49C@NDA-HCLT-EVS05.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Subranshu Patel - ERS, HCL Tech" <Subranshu.P@hcl.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758830Ab3BGQvf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2013 11:51:35 -0500
In-Reply-To: <60A0C755EDF2954AA9C18966C50DB31429E2A0A49C@NDA-HCLT-EVS05.HCLT.CORP.HCL.IN>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/7/13 12:48 AM, Subranshu Patel - ERS, HCL Tech wrote:
> I have an observation on EXT4 filesystem. I created filesystem of size 1TB, 4TB, and 7TB and then checked the output of df command. 
> 
> df command showed the number of 1KB blocks used. The result was:
> 1TB: 204056
> 4TB: 198680
> 7TB: 181784 
> 
> This trend was surprising, with increasing filesystem size, the number of used blocks decreased. Why it is so? 

I replied to your colleague who asked the same question.

Short answer is default ext4 behavior is to not count the large number of blocks used for metadata as "used", and on top of that there seems to be some inaccuracy in the overhead calculations.  See my other email for more detail.

-Eric
