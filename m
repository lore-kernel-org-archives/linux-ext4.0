From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 2/3] ext4 : Pass GFP_KERNEL for transaction allocation if
 caller can handler failures
Date: Tue, 25 Jan 2011 23:58:34 -0800
Message-ID: <AANLkTinHWuHo=vtT_r5gv8Ux08zaKmcudJfvKsiSQ-uR@mail.gmail.com>
References: <AANLkTinVBicZyTthnp5SjOoHUWHcKc1Css46RjpfEEnh@mail.gmail.com>
 <20110125161745.GC4088@quack.suse.cz> <AANLkTiniUaD8SN53BKFC2ayku-4m=4EATKxBc148d51G@mail.gmail.com>
 <alpine.LFD.2.00.1101260848050.2728@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49465 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1AZH6y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jan 2011 02:58:54 -0500
Received: by qyj19 with SMTP id 19so5430122qyj.19
        for <linux-ext4@vger.kernel.org>; Tue, 25 Jan 2011 23:58:54 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1101260848050.2728@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 25, 2011 at 11:55 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> Hi Manish,
>
> I might be very helpful to also improve commit description, because as
> it is it's very confusing and shallow, at least for me.

Sure, will update that too when I send the updated version.

-- 
Thanks -
Manish
