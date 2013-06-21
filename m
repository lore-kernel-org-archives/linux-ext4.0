From: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Subject: RE: ext4 file replace guarantees
Date: Fri, 21 Jun 2013 21:49:26 +0000
Message-ID: <C0F0BC787567C848B2C90989451123DA2363CAFF@ATLEXMBX4.ARRS.ARRISI.com>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <bf675d01f2290be4e38f602ce78643c9@josephdwagner.info>,<20130621210556.GB10582@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ryan Lortie <desrt@desrt.ca>
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Joseph D. Wagner" <joe@josephdwagner.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.arrisi.com ([216.234.147.109]:51803 "EHLO mail.arrisi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946231Ab3FUXSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jun 2013 19:18:33 -0400
In-Reply-To: <20130621210556.GB10582@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

But there is no need to mount entire fs with data journalling mode.
In fact I find per-file data journalling extremely useful. It would be even more useful if it allowed regular users to set journalling mode on specific file and there was some way to designate rewrite transaction boundaries (even 128k would cover a lot of small-but-important-file use cases).

As for now it is a best choice for app running with root privileges for rewriting files <= page size.

Regards,
Andrey.

________________________________________
From: linux-ext4-owner@vger.kernel.org [linux-ext4-owner@vger.kernel.org] on behalf of Theodore Ts'o [tytso@mit.edu]
Sent: Saturday, June 22, 2013 01:05
To: Joseph D. Wagner
Cc: linux-ext4@vger.kernel.org; Ryan Lortie
Subject: Re: ext4 file replace guarantees

On Fri, Jun 21, 2013 at 09:25:13AM -0700, Joseph D. Wagner wrote:
>
> Please forgive me for the stupid question.  Would Ryan's concerns be
> addressed by configuring ext4 to run in data=journal mode?

It would, but for most workloads, data=journal is much, much slower.

                                         - Ted