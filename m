From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3 v2] XFS TESTS: Fix 252 Failure: Relax fiemap filter
Date: Mon, 27 Jun 2011 22:17:12 -0700
Message-ID: <4E0963D8.5030002@linux.vnet.ibm.com>
References: <1309235247-32650-1-git-send-email-achender@linux.vnet.ibm.com> <1309235247-32650-2-git-send-email-achender@linux.vnet.ibm.com> <20110628045903.GK32466@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38098 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab1F1FRQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 01:17:16 -0400
In-Reply-To: <20110628045903.GK32466@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/27/2011 09:59 PM, Dave Chinner wrote:
> On Mon, Jun 27, 2011 at 09:27:25PM -0700, Allison Henderson wrote:
> I seriously dislike conditional parameter passing in shell scripts
> at the best of times, but for filter functions I really think it is
> the wrong thing to do. It significantly obfuscates the working of
> the function for no really good reason.
>
> Just write a new filter function, and factor out the common parts of
> them if the amount of code duplication is sufficient to make it
> desirable to do so.
>

Ok, it doesn't look like a lot of code, I can separate them into their
own functions.

>> +	md5sum $testfile | cut -d ' ' -f1
>
> Why cut out the file name? It's not like it changes at all....
>

Oh, it looked like there's a pid attached to the file name, so I thought 
I should remove that from the output

Allison Henderson


