From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Sun, 28 Oct 2012 22:42:24 -0400
Message-ID: <20121029024224.GD9365@thunk.org>
References: <20121027002258.GB31030@thunk.org>
 <873910xevu.fsf@spindle.srvr.nix>
 <20121027175534.GA7783@thunk.org>
 <87fw4zzra3.fsf@spindle.srvr.nix>
 <508C4FE5.1030102@redhat.com>
 <508C633F.4070100@redhat.com>
 <20121029010012.GE9161@thunk.org>
 <508DE8D3.1050101@redhat.com>
 <20121029023430.GB9365@thunk.org>
 <508DEB8E.10101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nix <nix@esperi.org.uk>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58213 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab2J2Cma (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Oct 2012 22:42:30 -0400
Content-Disposition: inline
In-Reply-To: <508DEB8E.10101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 28, 2012 at 09:35:58PM -0500, Eric Sandeen wrote:
> Yeah, seems that way.
> 
> Then your simpler version is probably the way to go.

If you have a chance, could you do me a favor and test my -v3 version
of the patch?  It should work just as well as yours, but I'm getting
paranoid in my old age, and you seem to have a reliable way of testing
for this failure.  I still need to figure out why my kvm based
approach isn't showing the problem....

Thanks,

-- Ted
