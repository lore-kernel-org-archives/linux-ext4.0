From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Oops with ext(3|4) and audit and Xen
Date: Mon, 8 Oct 2012 17:15:00 -0400
Message-ID: <20121008211500.GD22980@thunk.org>
References: <CALnj_=5eQ5vCmv8x3u-rJPzofqJr+WDJuYzkpZo8sLe0+B2AAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peter Moody <pmoody@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54471 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab2JHVPC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 17:15:02 -0400
Content-Disposition: inline
In-Reply-To: <CALnj_=5eQ5vCmv8x3u-rJPzofqJr+WDJuYzkpZo8sLe0+B2AAw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 08, 2012 at 11:19:53AM -0700, Peter Moody wrote:
> 
> I'm trying to track down a BUG() that seems to strike a particular
> system configuration (unfortunately, an increasingly common
> configuration), but does so with 100% reliability.

Peter, this looks like exactly the same issue that you asked me about
back in July, isn't it?  Check your corp e-mail archives for the
subject line: "advice/pointers on debugging a potential kernel race".

As I recall, the problem was a missing path_put() in audit_putname()
in kernel/auditsc.c?

					- Ted
