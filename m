From: "Eric A" <erpo41@gmail.com>
Subject: Re: barriers off by default?
Date: Mon, 12 May 2008 11:30:03 -0600
Message-ID: <72c5d9a0805121030y709de9cehc01df8aeb5b1b8d3@mail.gmail.com>
References: <482868A5.1000102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "ext4 development" <linux-ext4@vger.kernel.org>
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:14551 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbYELRaF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 May 2008 13:30:05 -0400
Received: by rv-out-0506.google.com with SMTP id l9so2761939rvb.1
        for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 10:30:03 -0700 (PDT)
In-Reply-To: <482868A5.1000102@redhat.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2008 at 9:56 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> As I look at my shiny new 500G disks with 32MB of cache, I find myself
>  wondering why the default for ext3 and ext4 is to have barriers disabled.
>
>  This is a pretty dangerous default w.r.t. filesystem integrity on power
>  loss, no?

>From reading the documentation, I was under the impression that write
barriers don't always do what they're supposed to do.

Cheers,
Eric
