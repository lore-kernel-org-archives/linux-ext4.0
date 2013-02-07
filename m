From: "Subranshu Patel - ERS, HCL Tech" <Subranshu.P@hcl.com>
Subject: df command on EXT4 and XFS filesystem
Date: Thu, 7 Feb 2013 12:18:26 +0530
Message-ID: <60A0C755EDF2954AA9C18966C50DB31429E2A0A49C@NDA-HCLT-EVS05.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gws05.hcl.com ([203.105.185.23]:35871 "EHLO gws05.hcl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab3BGG6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2013 01:58:24 -0500
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have an observation on EXT4 filesystem. I created filesystem of size 1TB, 4TB, and 7TB and then checked the output of df command. 

df command showed the number of 1KB blocks used. The result was:
1TB: 204056
4TB: 198680
7TB: 181784 

This trend was surprising, with increasing filesystem size, the number of used blocks decreased. Why it is so? 


::DISCLAIMER::
----------------------------------------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only.
E-mail transmission is not guaranteed to be secure or error-free as information could be intercepted, corrupted,
lost, destroyed, arrive late or incomplete, or may contain viruses in transmission. The e mail and its contents
(with or without referred errors) shall therefore not attach any liability on the originator or HCL or its affiliates.
Views or opinions, if any, presented in this email are solely those of the author and may not necessarily reflect the
views or opinions of HCL or its affiliates. Any form of reproduction, dissemination, copying, disclosure, modification,
distribution and / or publication of this message without the prior written consent of authorized representative of
HCL is strictly prohibited. If you have received this email in error please delete it and notify the sender immediately.
Before opening any email and/or attachments, please check them for viruses and other defects.

----------------------------------------------------------------------------------------------------------------------------------------------------

