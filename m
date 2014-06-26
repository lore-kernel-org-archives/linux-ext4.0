From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
Date: Thu, 26 Jun 2014 18:28:57 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406261827080.2172@localhost.localdomain>
References: <1403192228-25771-1-git-send-email-lczerner@redhat.com> <20140626162450.GD6826@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbaFZQ3G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jun 2014 12:29:06 -0400
In-Reply-To: <20140626162450.GD6826@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 26 Jun 2014, Theodore Ts'o wrote:

> Date: Thu, 26 Jun 2014 12:24:50 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, jack@suse.cz, stable@vger.kernel.org
> Subject: Re: [PATCH] ext4: Fix punch hole on files with indirect mapping
> 
> I like the performance improvement of your patch, but I'm concerned
> that it might be a bit too complicated to push outside of the merge
> window.
> 
> So what I propose doing is this.  We'll take Jan's patches and after
> testing, we'll push it to Linus.  Then for the the 3.17 merge window,
> after we've had more opportunity for testing and for other folks to
> review your changes, we can queue this patch (or its successor).
> 
> Does that seem like a good path forward?
> 
> 						- Ted

It does. But this is not exactly a critical bug and it has been
there since the introduction of punch hole for indirect file. But I
guess it's better to fix it sooner rather than later, so I am fine
with this.

Thanks!
-Lukas
