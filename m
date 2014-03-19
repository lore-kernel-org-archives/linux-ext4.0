From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: don't interact with a non tty
Date: Wed, 19 Mar 2014 16:16:36 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403191604150.5960@localhost.localdomain>
References: <1395162718-22586-1-git-send-email-psusi@ubuntu.com> <A5AC507A-847C-496C-99FF-DE48BE224D80@dilger.ca> <532894D9.4030409@ubuntu.com> <alpine.LFD.2.00.1403191217001.2119@localhost.localdomain> <53299D1F.6020307@ubuntu.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-30205961-1395242199=:5960"
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965109AbaCSPQm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 11:16:42 -0400
In-Reply-To: <53299D1F.6020307@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-30205961-1395242199=:5960
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Wed, 19 Mar 2014, Phillip Susi wrote:

> Date: Wed, 19 Mar 2014 09:35:27 -0400
> From: Phillip Susi <psusi@ubuntu.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] mke2fs: don't interact with a non tty
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 3/19/2014 7:26 AM, Lukáš Czerner wrote:
> > Yes, it is inconsistent especially in the way that mke2fs is 
> > proceeding without any problem on the device which already
> > contains a valid file system (or any other) signature. Which I
> > think we should really change. The problem is that this will break
> > scripts for everybody which is bad.
> > 
> > So my idea was to implement the signature check and then skip it
> > if we do not have a tty attached. Just to avoid the breakage.
> > 
> > However I do not think that we can just blindly ignore the checks
> > we already have in place in the case that there is no user. But I
> > agree that current behaviour is wrong and it should be changed,
> > however I think that we need to change it the other way, the
> > default should be no - do not proceed and exit. Because believe it
> > or not, people make mistakes.
> 
> Then you are right back to breaking scripts.  And yes, people make
> mistakes... and unix *lets* them.  You don't see rm stopping every
> time you try to delete a file and saying really?  *That* file?  Are
> you sure?  You don't see dd or shell redirection stopping to ask you
> if you really meant to overwrite that disk or file.  There is a
> *reason* why you are supposed to double check commands you are running
> as root.

Then again, many distributions actually do:

alias rm='rm -i'

and they have reason for it.

> 
> And putting a filesystem in an image file is one of the *least*
> dangerous things you could do.  Of all of the things to second guess,
> and especially to default to "HALT! ERROR!" behavior, this has to be
> the silliest.
> 
> If you can't assume that an interactive user knows what they are doing
> and meant what they said, then at least you should assume that a
> script writer knows wtf they are doing without asking them to add lots
> of silly --yes-i-know-what-im-doing-stop-annoying-me flags.
> 
> > Agreed, but it should not be lifted, but rather changes to check
> > for signatures on the device. The same way as it is done for
> > example in xfs, or btrfs.
> 
> *NO*!  Those tools annoy the hell out of me because they do that.  I
> *know* there is another filesystem there already ( as there are on
> most disks not fresh from the factory ), why do you think I'm telling
> you to change it?  Do what I asked and stop treating me like a child.

There was a discussion between me and Dave Chinner a while ago about
exactly this topic and he made some very good points. You as a guy
working with file system, or file system utilities, testing them and
so on will probably see a ton of the warning like that. But like it,
or not you're *not* the typical user - you're a developer and there
is a huge difference.

While you recreate a file system on a device hundreds times in a
day, it is not at all typical behaviour. Sysadmins will buy a disk,
create a partition table (or not) and create a file system on it -
DONE. They would probably never touch the disk again until something
breaks.

So when they are trying to create a file system on a device that
already have a valid signature (file system, lvm, partition ...)
it is very likely they made a mistake. And the file system utilities
are trying to minimize that by either asking for confirmation (as
mke2fs does) or straight up fail if you not force them.

So again, the fact that it annoys the hell out of you as a developer
is not really a reason to remove this safety net for every sysadmin
in the world. You're not the target audience of such measures :)

Thanks!
-Lukas

> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBAgAGBQJTKZ0fAAoJEI5FoCIzSKrwaFQH/RO0NPl2mPAlpaK2YQysegub
> u80nYpSlpHjiIOLU7RCECakfELIFp1skg7lRsFdL1zLNkor4JkwW8UbOuy75WbS3
> +XPAQ/1wxPzsn0J4+QM3PE3X/IZ4NWRMepl0pozpoLine87mL6u6+em2n1r1vsQK
> HE/1Ma/8jqPPMXPNFDw0LMiYGyAHITfQA4c/FRwlWCbhMt2lG8dsGA7bKl7VCB5D
> gmkzUF/KbgmY8xnDiIbmSHQbaF+xrIbZl8FGgi4r3CuiGZ2yZBBbs2sTCk6pvIq7
> rrTQGwxBuzxaas2h+ZpLfTeFulBlIH2B+ueStinc2Br+TmBeqIKKOQ1+HjO3v6g=
> =6eGY
> -----END PGP SIGNATURE-----
> 
--8323328-30205961-1395242199=:5960--
