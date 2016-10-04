From: Andrey Korolyov <andrey@xdel.ru>
Subject: Re: Frequent ext4 oopses with 4.4.0 on Intel NUC6i3SYB
Date: Tue, 4 Oct 2016 21:45:32 +0300
Message-ID: <CABYiri-UUT6zVGyNENp-aBJDj6Oikodc5ZA27Gzq5-bVDqjZ4g@mail.gmail.com>
References: <fcb653b9-cd9e-5cec-1036-4b4c9e1d3e7b@gmx.de> <20161004084136.GD17515@quack2.suse.cz>
 <90dfe18f-9fe7-819d-c410-cdd160644ab7@gmx.de> <2b7d6bd6-7d16-3c60-1b84-a172ba378402@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org
To: Johannes Bauer <dfnsonfsduifb@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:35338 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752778AbcJDSpx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Oct 2016 14:45:53 -0400
Received: by mail-yw0-f180.google.com with SMTP id t193so60039390ywc.2
        for <linux-ext4@vger.kernel.org>; Tue, 04 Oct 2016 11:45:52 -0700 (PDT)
In-Reply-To: <2b7d6bd6-7d16-3c60-1b84-a172ba378402@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 4, 2016 at 8:32 PM, Johannes Bauer <dfnsonfsduifb@gmx.de> wrote:
> On 04.10.2016 18:50, Johannes Bauer wrote:
>
>> Uhh, that sounds painful. So I'm following Ted's advice and building
>> myself a 4.8 as we speak.
>
> Damn bad idea to build on the instable target. Lots of gcc segfaults and
> weird stuff, even without a kernel panic. The system appears to be
> instable as hell. Wonder how it can even run and how much of the root fs
> is already corrupted :-(
>
> Rebuilding 4.8 on a different host.

Looks like a platform itself is somewhat faulty: [1]. Also please bear
in mind that standalone memory testers would rather not expose certain
classes of memory failures, I`d suggest to test allocator`s work
against gcc runs on tmpfs, almost same as you did before. Frequency of
crashes due to wrong pointer contents of an fs cache is most probably
a direct outcome from its relative memory footprint.

1. https://communities.intel.com/thread/105640
