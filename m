From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Ext4 performance regression: Post 2.6.30
Date: Mon, 29 Mar 2010 11:10:55 -0400
Message-ID: <87f94c371003290810u58f64ce6uc20be6bbac420e73@mail.gmail.com>
References: <1269843935.13369.52.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Keith Mannthey <kmannth@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61589 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0C2PK7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Mar 2010 11:10:59 -0400
Received: by gyg13 with SMTP id 13so1489513gyg.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 08:10:58 -0700 (PDT)
In-Reply-To: <1269843935.13369.52.camel@keith-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 29, 2010 at 2:25 AM, Keith Mannthey <kmannth@us.ibm.com> wrote:
>
>
> After 2.6.30 I am seeing large performance regressions on a raid setup.
> I am working to publish a larger amount of data but I wanted to get some
> quick data out about what I am seeing.
>

Is mdraid involved?

They added barrier support for some configs after 2.6.30 I believe.
It can cause a drastic perf change, but it increases reliability and
is "correct".

Greg
