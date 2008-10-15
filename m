From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Possible ext3 corruption with 1K block size
Date: Wed, 15 Oct 2008 09:43:49 -0500
Message-ID: <48F601A5.1050405@redhat.com>
References: <200810150724.42180.arvidjaar@mail.ru> <48F5E6D4.8080603@redhat.com> <200810151824.36119.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pterjan@mandriva.org, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52999 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbYJOOoG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Oct 2008 10:44:06 -0400
In-Reply-To: <200810151824.36119.arvidjaar@mail.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrey Borzenkov wrote:
> On Wednesday 15 October 2008, Eric Sandeen wrote:


>> My kingdom for a testcase... does anyone have simple steps to reproduce
>> this?  Or do they all start with "install mandriva on a 1k block size
>> system?"  :)
>>
> 
> May be RH will do? :)

I did try a 1k-block root fs Fedora install, and didn't see any problems...

> As indicated by last comment, Pascal has some ways to trigger it; I
> forgot to Cc to him initially; doing it now.

Ok, good deal.

-Eric
