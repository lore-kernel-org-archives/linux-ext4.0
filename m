From: Josh Boyer <jwboyer@gmail.com>
Subject: Re: EXT4: lockdep complaints on 3.1-rc4+
Date: Tue, 20 Sep 2011 13:59:05 -0400
Message-ID: <CA+5PVA7WA6QorzgiOHEDw9HCoLO0UbGYMS34r3Ds01w854YoHA@mail.gmail.com>
References: <20110920175551.GA4187@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f52.google.com ([209.85.212.52]:55135 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1ITR7H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Sep 2011 13:59:07 -0400
In-Reply-To: <20110920175551.GA4187@core.coreip.homeip.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 20, 2011 at 1:55 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi,
>
> Not sure if it has been reported but I just got the following lockdep
> warning on 3.1-rc4+ + my input queue (which does not touch FS code at
> all):

IIRC, that should be fixed with
8c0bec2151a47906bf779c6715a10ce04453ab77, which is in -rc5

josh
