From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: jbd2_journal_add_journal_head() failed
Date: Sun, 6 Jul 2014 14:40:04 -0400
Message-ID: <20140706184004.GC471@thunk.org>
References: <9F136EE5FB53D64397ED1089A0E760E016294F04@SJEXCHMB12.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Joel (Xi Zhou) Zhou" <joel.zhou@broadcom.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47742 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbaGFSkK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jul 2014 14:40:10 -0400
Content-Disposition: inline
In-Reply-To: <9F136EE5FB53D64397ED1089A0E760E016294F04@SJEXCHMB12.corp.ad.broadcom.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 06, 2014 at 04:09:04PM +0000, Joel (Xi Zhou) Zhou wrote:
> Hi all,
> 
> I'm trying to use ext4 on USB stick. It is a big endian kernel on ARM Cortex-A9 with busybox.
> The system command( cp /cat / ls ...) failed randomly in jbd2_journal_add_journal_head() on the following instruction.
> The full log in the end.

I don't recall any bug report even vaguely like this.  I note you are
using a fairly ancient kernel --- version 3.6.5.  Can you reproduce it
on anything more modern?

Regards,

					- Ted
