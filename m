From: supersud501 <supersud501@yahoo.de>
Subject: Re: [PATCH, RFC] Add new "development flag" to the ext4 filesystem
Date: Wed, 30 Jan 2008 23:26:20 +0100
Message-ID: <47A0F98C.1080304@yahoo.de>
References: <20080122231707.GA21968@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp002.mail.ukl.yahoo.com ([217.12.11.33]:37183 "HELO
	smtp002.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753926AbYA3W3z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 17:29:55 -0500
In-Reply-To: <20080122231707.GA21968@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> As discussed on RFC, this flag is simply a generic "this is a
> crash/burn test filesystem" marker.  If it is set, then filesystem
> code which is "in development" will be allowed to mount the
> filesystem.  Filesystem code which is not considered ready for
> prime-time will check for this flag, and if it is not set, it will
> refuse to touch the filesystem.
> 
> As we start rolling ext4 out to distro's like Fedora, et. al, this
> makes it less likely that a user might accidentally start using ext4
> on a production filesystem; a bad thing, since that will essentially
> make it be unfsckable until e2fsprogs catches up.
> 
> 						- Ted
> 
> 

how can i set this "flag" on my filesystem? i've never set any flags 
before so i just removed the code from ext4-module to mount my 
filesystems, but setting the flag once would make it easier i think :)
