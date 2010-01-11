From: Jeff Layton <laytonjb@att.net>
Subject: Re: Default size of journal?
Date: Mon, 11 Jan 2010 06:37:48 -0500
Message-ID: <4B4B0D8C.4030209@att.net>
References: <4B4A26B6.805@att.net> <1D207FF6-B457-4DF3-B7B0-F4090EB8CED5@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.re3.yahoo.com ([66.196.96.96]:35884 "HELO
	smtp123.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753255Ab0AKLoN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jan 2010 06:44:13 -0500
In-Reply-To: <1D207FF6-B457-4DF3-B7B0-F4090EB8CED5@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2010-01-10, at 15:12, Jeff Layton wrote:
>> I'm sorry if this is a repeat, but I was wondering what the
>> default journal size is for ext4  when it's built on a single
>> partition? Or does it vary in size as needed?
>
> It varies with the size of the filesystem.  I believe the largest 
> default size is 128MB, but I don't know offhand what the cutoff size is.

Is there a simple formula for how the journal size varies with the
file system size? Perhaps linear?

Thanks!

Jeff

