From: Andrey Korolyov <andrey@xdel.ru>
Subject: Re: Frequent ext4 oopses with 4.4.0 on Intel NUC6i3SYB
Date: Tue, 4 Oct 2016 23:17:08 +0300
Message-ID: <CABYiri_3qS6XgT04hCeF1AMuxY6W0k7QVEO-N0ZodeJTdG=xsw@mail.gmail.com>
References: <fcb653b9-cd9e-5cec-1036-4b4c9e1d3e7b@gmx.de> <20161004084136.GD17515@quack2.suse.cz>
 <90dfe18f-9fe7-819d-c410-cdd160644ab7@gmx.de> <2b7d6bd6-7d16-3c60-1b84-a172ba378402@gmx.de>
 <CABYiri-UUT6zVGyNENp-aBJDj6Oikodc5ZA27Gzq5-bVDqjZ4g@mail.gmail.com> <087b53e5-b23b-d3c2-6b8e-980bdcbf75c1@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org
To: Johannes Bauer <dfnsonfsduifb@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:35875 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754059AbcJDURa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Oct 2016 16:17:30 -0400
Received: by mail-yw0-f172.google.com with SMTP id u124so49467551ywg.3
        for <linux-ext4@vger.kernel.org>; Tue, 04 Oct 2016 13:17:29 -0700 (PDT)
In-Reply-To: <087b53e5-b23b-d3c2-6b8e-980bdcbf75c1@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I'm super puzzled right now :-(
>

There are three strawman` ideas out of head, down by a level of
naiveness increase:
- disk controller corrupts DMA chunks themselves, could be tested
against usb stick/sd card with same fs or by switching disk controller
to a legacy mode if possible, but cascading failure shown previously
should be rather unusual for this,
- SMP could be partially broken in such manner that it would cause
overlapped accesses under certain conditions, may be checked with
'nosmp',
- disk accesses and corresponding power spikes are causing partial
undervoltage condition somewhere where bits are relatively freely
flipping on paths without parity checking, though this could be
addressed only to an onboard power distributor, not to power source
itself.
