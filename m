From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: e4defrag and immutable files
Date: Fri, 28 May 2010 15:06:55 -0700
Message-ID: <4C003E7F.7060204@zytor.com>
References: <4C002427.3010706@zytor.com> <AANLkTikM11wkmzq7NtAOyz0fz88oe1bp9T2VQw0sK_Y8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:48846 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab0E1WHB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 May 2010 18:07:01 -0400
In-Reply-To: <AANLkTikM11wkmzq7NtAOyz0fz88oe1bp9T2VQw0sK_Y8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/28/2010 02:21 PM, Greg Freemyer wrote:
>
> Other projects / tools than e4defrag use EXT4_IOC_MOVE_EXT, so it
> would be best to do this in the kernel in my opinion.
>

I fully agree.  If nothing else, it will provide protection against 
broken userspace programs.

	-hpa
