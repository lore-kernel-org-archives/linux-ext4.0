From: Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [RFC PATCH 0/3] VFS: Fix s_umount thaw/write deadlock
Date: Sat, 29 Oct 2011 17:59:40 -0700
Message-ID: <CAD-Xujn--+2pRMrk2OJvCbH6nbG+wiGOPp8CRAm=a8MagqV8JQ@mail.gmail.com>
References: <CAD-Xujmjai2evYC4a4CdNPtjh_9xhbELcZePtGSS54VPRGpznA@mail.gmail.com>
	<20111027213935.GA20902@infradead.org>
	<CAD-XujmonJPfq9zUaL-ZS6zz5dfgvxtcjJwxwrxpR33LohvK9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49181 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab1J3A7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Oct 2011 20:59:42 -0400
In-Reply-To: <CAD-XujmonJPfq9zUaL-ZS6zz5dfgvxtcjJwxwrxpR33LohvK9g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 27, 2011 at 3:08 PM, Valerie Aurora <val@vaaconsulting.com>=
 wrote:
> On Thu, Oct 27, 2011 at 2:39 PM, Christoph Hellwig <hch@infradead.org=
> wrote:
>> Any plans to resubmit these with the updates and in proper format?
>
> Yes, coming tomorrow. =A0We found more bugs during testing which
> fortunately Surbhi Palande already fixed and submitted patches for,
> but got lost in the shuffle.

Ironically, this has been held up by a disk failure. :) A few more days=
=2E

-VAL
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
