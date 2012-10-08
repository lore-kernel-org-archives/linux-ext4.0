From: "George Spelvin" <linux@horizon.com>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: 8 Oct 2012 07:35:03 -0400
Message-ID: <20121008113503.9729.qmail@science.horizon.com>
References: <5072508E.3040806@tao.ma>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: linux@horizon.com, tm@tao.ma
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:26308 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751324Ab2JHLfF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2012 07:35:05 -0400
In-Reply-To: <5072508E.3040806@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tao Ma <tm@tao.ma> wrote:
> This line is already removed in my commit bef53b01 and will be in
> stable. So this patch should work as expected.

Ah, okay.  Well, with that, it appears to be working; I can't
reproduce the problem any more.

Thanks to everyone for a significant bugfix starting with a vague
report over a weekend!
