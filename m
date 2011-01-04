From: YangSheng <sickamd@gmail.com>
Subject: Re: [PATCH resend] Update atime from future.
Date: Tue, 04 Jan 2011 17:05:19 +0800
Message-ID: <4D22E2CF.5050002@gmail.com>
References: <1294131418-3835-1-git-send-email-sickamd@gmail.com> <m2d3od11p6.fsf@whitebox.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, adilger@dilger.ca,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	swhiteho@redhat.com, sickadm@gmail.com
To: Andreas Schwab <schwab@linux-m68k.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41135 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1ADJFb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jan 2011 04:05:31 -0500
In-Reply-To: <m2d3od11p6.fsf@whitebox.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/04/2011 05:02 PM, Andreas Schwab wrote:
> yangsheng<sickamd@gmail.com>  writes:
>
>    
>> -	 * Is the previous atime value older than a day? If yes,
>> +	 * Is the previous atime value old than a day? If yes,
>>      
> Why did you change that comment?
>    
Sorry, It is a typo. I'll resent it.
> Andreas.
>
>    

