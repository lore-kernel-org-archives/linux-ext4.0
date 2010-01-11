From: Jeff Layton <laytonjb@att.net>
Subject: Re: Default size of journal?
Date: Mon, 11 Jan 2010 06:40:01 -0500
Message-ID: <4B4B0E11.8000101@att.net>
References: <4B4A26B6.805@att.net> <1D207FF6-B457-4DF3-B7B0-F4090EB8CED5@sun.com> <4B4B0D8C.4030209@att.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.ac4.yahoo.com ([76.13.13.241]:27441 "HELO
	smtp102.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752018Ab0AKLjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jan 2010 06:39:41 -0500
In-Reply-To: <4B4B0D8C.4030209@att.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeff Layton wrote:
> Andreas Dilger wrote:
>> On 2010-01-10, at 15:12, Jeff Layton wrote:
>>> I'm sorry if this is a repeat, but I was wondering what the
>>> default journal size is for ext4  when it's built on a single
>>> partition? Or does it vary in size as needed?
>>
>> It varies with the size of the filesystem.  I believe the largest 
>> default size is 128MB, but I don't know offhand what the cutoff size is.
>
> Is there a simple formula for how the journal size varies with the
> file system size? Perhaps linear?
Disregard - Eric answered it for me (didn't finish all my email before
responding). Apologies.

Jeff

