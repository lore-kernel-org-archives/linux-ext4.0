From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] chattr manpage tidyups
Date: Thu, 28 May 2009 09:12:10 -0400
Message-ID: <20090528131210.GN26625@mit.edu>
References: <4A1E11CF.1000502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55412 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761232AbZE1NMT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 09:12:19 -0400
Content-Disposition: inline
In-Reply-To: <4A1E11CF.1000502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 27, 2009 at 11:23:43PM -0500, Eric Sandeen wrote:
> This was prompted by RH BZ#502971
> 
> Note that this goes after Aneesh's patch to add chattr +e
> 
> Tidy up the chattr(1) manpage to completely document all
> available options, and differentiate those which are read-only
> early in the manpage as well.
> 
> * Remove "I" from settable attribute list
> * add "e" to 2nd list of settable attributes & descriptions
> * Note that h/E/I/X/Z are readonly
> * Correct "H" to "h" for huge file attribute description
> * fix long_name for indexed directory in flags_array

Thanks, applied.

					- Ted
