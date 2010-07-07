From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Ext3: batched discard support
Date: Wed, 7 Jul 2010 15:14:16 -0400
Message-ID: <AANLkTil_Y6rjgbAjQcOqTeFUt1WO46MNKFp5Qe4iSK3z@mail.gmail.com>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41763 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab0GGTOQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jul 2010 15:14:16 -0400
Received: by iwn7 with SMTP id 7so9522iwn.19
        for <linux-ext4@vger.kernel.org>; Wed, 07 Jul 2010 12:14:16 -0700 (PDT)
In-Reply-To: <1278508727-29135-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 7, 2010 at 9:18 AM, Lukas Czerner <lczerner@redhat.com> wrote:
>
> Hello again,
>
> I have composed a set of patches to add batched discard support for Ext3 file
> system. Functionality is basically the same as in "batched discard support
> for Ext4" (see http://www.spinics.net/lists/linux-ext4/msg19827.html ).
>
> There are two patches:

I'm inclined to review these, but before I do, I thought ext3 was
closed to patches like this.

Or is it still accepting more new functionality than I thought?

Greg
