From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: why has "fix ext4_ext_remove_space tree traversal" not been
 applied?
Date: Tue, 6 Nov 2012 09:40:25 -0500
Message-ID: <20121106144025.GA9377@thunk.org>
References: <20632.64737.272834.202562@fisica.ufpr.br>
 <20121106131751.GA3242@thunk.org>
 <20633.5411.781195.220149@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59628 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab2KFOka (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2012 09:40:30 -0500
Content-Disposition: inline
In-Reply-To: <20633.5411.781195.220149@fisica.ufpr.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 06, 2012 at 11:48:19AM -0200, Carlos Carvalho wrote:
> Sure. I asked because we're having serious problems with a released
> version (3.5.2), so an available fix should have already been applied
> somewhere and I didn't recognize it. Dmitry sent the link that shows
> this is the case. Now we'll go to 3.6.6.

3.5.2 is not a long-term stable release, so the last 3.5.x kernel was
3.5.7 released on 2012-10-12.  See http://www.kernel.org and note the
'EOL' next to the version.

Regards,

						- Ted
