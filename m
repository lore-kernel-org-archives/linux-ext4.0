From: supersud501 <supersud501@yahoo.de>
Subject: Re: e2fsck (git) on ext4: unsupported feature(s): huge_file
Date: Fri, 11 Apr 2008 15:38:47 +0200
Message-ID: <47FF69E7.8070807@yahoo.de>
References: <47FBB24D.90807@yahoo.de> <47FBBB13.7060501@redhat.com> <47FBCB44.1050500@yahoo.de> <20080408210048.GA16108@mit.edu> <47FC892C.5080000@yahoo.de> <20080409161117.GB26924@mit.edu> <47FD0724.4060307@yahoo.de> <20080409190634.GA9430@mit.edu> <47FD16DC.1090502@yahoo.de> <20080409210856.GD9430@mit.edu> <20080411130412.GA10551@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n29.bullet.mail.ukl.yahoo.com ([87.248.110.146]:20858 "HELO
	n29.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751768AbYDKNix (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 09:38:53 -0400
In-Reply-To: <20080411130412.GA10551@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Apr 09, 2008 at 05:08:56PM -0400, Theodore Tso wrote:
>> Whoops, I had a one-character typo in e2fsck.  Try this patch
>> instead.... (made against git the next branch).
> 
> Hi, have you had a chance to try this updated patch?
> 
> Thanks,
> 
> 							- Ted
> 

yes, i had, the mass of errors were not there anymore.

and the errors of the type "i_blocks is x, should be y" were not always 
of the type x+8 like before but more random, so that it looked like as 
if it was correcting them right.

unfortunately i cannot make any further tests, because i just 
reformatted the drive with ext3, to avoid further complications (and to 
be able to use the drive on windows machines, too).

my second (and now only) ext4dev test-filesystem has no huge_file flag, 
so i think i'm out of further testing the patch.

regards,
supersud501

