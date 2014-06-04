From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [2/4 v2] e2fsck: make a prompt message simpler and thus
 translatable
Date: Wed, 4 Jun 2014 08:56:50 -0400
Message-ID: <20140604125650.GF27426@thunk.org>
References: <20140602234001.GJ30598@thunk.org>
 <1401827722-13286-1-git-send-email-bensberg@justemail.net>
 <20140604020719.GC27426@thunk.org>
 <1401884601.6870.125052445.0CA47507@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benno Schulenberg <bensberg@justemail.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49831 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbaFDM4y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2014 08:56:54 -0400
Content-Disposition: inline
In-Reply-To: <1401884601.6870.125052445.0CA47507@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2014 at 02:23:21PM +0200, Benno Schulenberg wrote:
> 
> Running 'make check' now, I see these messages along the way:
> 
> mktemp: too few X's in template `r_64bit_big_expand.XXXXXX.tmp'

Hmm... what OS and if Linux, version of coreutils are you using?

On my system, from "man mktemp":

       Create a temporary file or directory, safely, and print its
       name.  TEMPLATE must contain at least 3 consecutive 'X's in
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
       last component.
       ^^^^^^^^^^^^^^^

					- Ted
