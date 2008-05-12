From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: barriers off by default?
Date: Mon, 12 May 2008 12:53:01 -0500
Message-ID: <482883FD.8060001@redhat.com>
References: <482868A5.1000102@redhat.com> <72c5d9a0805121030y709de9cehc01df8aeb5b1b8d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric A <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbYELRxE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 13:53:04 -0400
In-Reply-To: <72c5d9a0805121030y709de9cehc01df8aeb5b1b8d3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric A wrote:
> On Mon, May 12, 2008 at 9:56 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> As I look at my shiny new 500G disks with 32MB of cache, I find myself
>>  wondering why the default for ext3 and ext4 is to have barriers disabled.
>>
>>  This is a pretty dangerous default w.r.t. filesystem integrity on power
>>  loss, no?
> 
> From reading the documentation, I was under the impression that write
> barriers don't always do what they're supposed to do.

Which documentation?

Thanks,
-Eric
