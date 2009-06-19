From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC][PATCH 0/3]ext4: online defrag (ver 2.0)
Date: Fri, 19 Jun 2009 11:31:20 -0400
Message-ID: <87f94c370906190831j4e1d7146k559c272e0ff7ddad@mail.gmail.com>
References: <4A164EC9.3070405@rs.jp.nec.com>
	 <87f94c370906111603l4ed1c383tf0d725cb5ac95eaf@mail.gmail.com>
	 <200906120947.58071.andreas.philipp@uni-graz.at>
	 <87f94c370906120631i386acb94tb1039626c765ef60@mail.gmail.com>
	 <4A3BA67B.9020803@aipe.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Philipp <andreas.philipp@aipe.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:2714 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZFSPjh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jun 2009 11:39:37 -0400
Received: by an-out-0708.google.com with SMTP id d40so2916288and.1
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2009 08:39:40 -0700 (PDT)
In-Reply-To: <4A3BA67B.9020803@aipe.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 19, 2009 at 10:53 AM, Andreas
Philipp<andreas.philipp@aipe.at> wrote:
> Greg Freemyer wrote:
>> On Fri, Jun 12, 2009 at 3:47 AM, Andreas
>> Philipp<andreas.philipp@uni-graz.at> wrote:
>>
>>> Maybe my question is stupid, but I'll post it anyway. Where can I get the
>>> patches for online defrag?
>>>
>>> Thanks,
>>> Andreas
>>>
>>> --
>>> Andreas Philipp
>>>
>>
>> Akira Fujita posted them last month.
>>
>> http://markmail.org/search/?q=Akira+Fujita+#query:Akira Fujita date%3A200905
>>
>> Greg
>>
>
> I sucessfully applied them on top of 2.6.30-git3. Please don't hesitate
> to contact me, if you need anyone running some tests or something like that.
>
> Andreas

Ted also pushed them as part of the 2.6.31 merge window, so testers
will be able to test with 2.6.30-git14 or newer without having to
apply the patches separately..

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
