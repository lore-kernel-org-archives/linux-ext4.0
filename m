From: Christian Brandt <brandtc@psi5.com>
Subject: Re: fsck.ext4 taking months
Date: Tue, 29 Mar 2011 22:26:54 +0200
Message-ID: <4D92408E.7090008@psi5.com>
References: <4D8F1F75.8010201@psi5.com> <4D909E92.4080209@redhat.com> <20110329060300.GA27142@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:45806 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1C2U04 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 16:26:56 -0400
In-Reply-To: <20110329060300.GA27142@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am 29.03.2011 08:03, schrieb Rogier Wolff:

>>> >>> Is the slow performance with lots of hard links a known issue?
> >
> > Yes, it is a known issue.

 At least its not my fault :-) thanks for the info.

> > You get to test my patch. :-)
> >
> > I strongly suspect that (just like me) sometime in the past you've
> > seen e2fsck run out of memory and were advised to enable the
> > on-disk-databases.

 Something like that... The drive has been formatted recently but a bad
controller corrupted vital information upon mount and some more on the
next fsck. I Ctrl-C pretty fast when I saw lots of rather confusing
kernel errors between fsck output. This could have left the drive in a
similiar state, couldn't it?

-- Christian Brandt

 life is short and in most cases it ends with death but my tombstone
will carry the hiscore
