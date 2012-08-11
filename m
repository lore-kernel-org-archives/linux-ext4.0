From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: add max_dir_size_kb mount option
Date: Sat, 11 Aug 2012 17:13:13 -0400
Message-ID: <20120811211313.GA906@thunk.org>
References: <20120810215811.GA1137@thunk.org>
 <1344649235-9289-1-git-send-email-tytso@mit.edu>
 <C9EF93CD-99DF-483E-BE66-713616B12D8C@whamcloud.com>
 <20120811192648.GA9363@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44164 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab2HKVNQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Aug 2012 17:13:16 -0400
Content-Disposition: inline
In-Reply-To: <20120811192648.GA9363@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 11, 2012 at 03:26:48PM -0400, Theodore Ts'o wrote:
> On Fri, Aug 10, 2012 at 09:22:39PM -0600, Andreas Dilger wrote:
> > 
> > In our patch, it returns EFBIG, since it isn't really a case of
> > being out of space for blocks or inodes.
> 
> I agree, EFBIG seems to be a better errno.

Hmmm..... upon doing some more research, there was a related
discussion on this point on the IETF NFSv4 mailing list earlier this
year[1].  In it, Trond argued that EFBIG is defined by POSIX to mean:
"An attempt was made to write a file that exceeds the file size limit
of the process.", while ENOSPC is explicitly documented as an
allowable error code for rename(2):

[ENOSPC]
   The directory that would contain new cannot be extended.

The same definition is there for link(2) and open(2).  For open, it
reads:

[ENOSPC]
    The directory or file system that would contain the new file
    cannot be expanded, the file does not exist, and O_CREAT is
    specified.

Hence, Trond argued that using ENOSPC was a better choice, in terms of
being a closer match with POSIX specifications, and hence what
programs might expect.

The string returned by perror/strerror is going to be a little
confusing to users in either case.  EFBIG returns "File too large",
while ENOSPC returns "No space left on device".  One might argue that
ENOSPC's error return is a little better, but then again there's a
grand Unix tradition in this, after all --- "Not a typewriter",
anyone?  :-)

						- Ted

[1] http://www.ietf.org/mail-archive/web/nfsv4/current/msg10720.html

P.S.  The context for this is a feature which the NetApp filer has,
MaxDirSize, which controls the maximum size of a directory specified
in Kilobytes.  The discussion was what was the proper NFS error code
that should be returned, given how it would be reflected back to a
Posix errno by most clients.

Interestingly, it appears the default MaxDirSize starting with
NetApp's Data before ONTAP 6.5 was 64k.  On newer NetApps, the limit
is defaulted to be 1% of the memory size configured on the filer.  The
reason given for limiting the maximum directory size was for
performance reasons.  Given the issues we've seen when you have jobs
running with a 512mb memory cgroup (which would also apply if you were
running a micro EC2 instance, or some other Xen or KVM VM with a small
memory size), it's interesting that this was an issue that NetApp has
run into, and addressed the same way.

I can definitely attest to the fact that the system will not be happy
if you are limited to 512mb of memory, and you have a 176mb
directory....
