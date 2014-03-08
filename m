From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [e2fsprogs][1.42.9 to lastest]maybe a bug
Date: Sat, 8 Mar 2014 10:41:06 -0500
Message-ID: <20140308154106.GB11633@thunk.org>
References: <CAEazTgcqTQuSUCHJ7T4fYGuCydOGcFfTW2=kjTrpSxWZW61zoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sela Selah <selahsolar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38760 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaCHPlK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Mar 2014 10:41:10 -0500
Content-Disposition: inline
In-Reply-To: <CAEazTgcqTQuSUCHJ7T4fYGuCydOGcFfTW2=kjTrpSxWZW61zoA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 08, 2014 at 10:46:03AM +0800, Sela Selah wrote:
> appear at version 1.42.9 to the lastest commit
> the if statements is *NOT* consisted with the comments, results a  compile
> error on mips64el: the __u64/__s64 should unsigned/signed long but
> unsigned/signed long long.

What's the compile error which you are seeing with mips64el?

The change made to prefer [un]signed long long over [un]signed long
when both types are 64-bits was deliberate:

commit 3a941bef3b9036ca3db9d510c71bcae801ea4dd1
Author: Andreas Dilger <adilger@dilger.ca>
Date:   Sun Dec 15 22:09:24 2013 -0500

    build: use long long for __u64 by default
    
    Don't print a verbose configure error in parse-types.h if
    <asm/types.h> missing and __[SU]*_TYPEDEF is unset.  This is
    always the case for non-Linux builds.
    
    The printf formatting strings all use "%llu" for printing 64-bit
    values and this it produces a large number of warnings if __u64
    is defined as "unsigned long".  If __U64_TYPEDEF isn't set use
    "unsigned long long" for __u64 in ext2-types.h and blkid-types.h
    by default instead of using "unsigned long".
    
    Fix a few places where "%d" or "%u" or "%Lu" were used to print a
    64-bit value, by converting them to use "%lld" or "%llu" instead.
    
    Fix a few places where "%lu" was used to print .tv_usec, by casting
    the variable to "(long)" since .tv_usec is "int" on some systems.
    
    Signed-off-by: Andreas Dilger <adilger@dilger.ca>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Andreas didn't fix up the comments in the header file, but the change
made wasn't an accident.

Maybe there's some other way we can address the compile failure on
mips64el?

						- Ted
