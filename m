From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V2] lsattr: return error values
Date: Sun, 21 Jun 2009 21:48:01 -0400
Message-ID: <20090622014801.GA26079@mit.edu>
References: <4A3AB8AD.6000100@redhat.com> <4A3AC4DB.2030609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57005 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbZFVBsD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jun 2009 21:48:03 -0400
Content-Disposition: inline
In-Reply-To: <4A3AC4DB.2030609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 18, 2009 at 05:51:07PM -0500, Eric Sandeen wrote:
> (hastily redone before I leave for a few days, hope this
> is sane, review welcome) :)
> 
> lsattr doesn't return an error if you point it at a file that 
> doesn't exist.
> 
> This is slightly trickier because it can take more than one
> file as an arg, but ls seems to report an error if any occurred,
> so this does the same, it'll report the last error that was 
> encountered.
> 
> Addresses-RedHat-Bugzilla: #489841
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

						- Ted
