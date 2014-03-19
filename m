From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: don't interact with a non tty
Date: Wed, 19 Mar 2014 12:26:38 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403191217001.2119@localhost.localdomain>
References: <1395162718-22586-1-git-send-email-psusi@ubuntu.com> <A5AC507A-847C-496C-99FF-DE48BE224D80@dilger.ca> <532894D9.4030409@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602AbaCSL0o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 07:26:44 -0400
In-Reply-To: <532894D9.4030409@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 18 Mar 2014, Phillip Susi wrote:

> Date: Tue, 18 Mar 2014 14:47:53 -0400
> From: Phillip Susi <psusi@ubuntu.com>
> To: Andreas Dilger <adilger@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] mke2fs: don't interact with a non tty
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 3/18/2014 2:31 PM, Andreas Dilger wrote:
> > This means that mke2fs will silently continue to format whatever
> > accidental device was specified on the command line, instead of
> > stopping and asking the user for confirmation.  Instead, it should
> > exit with an error in this case.
> 
> There *is* no user to ask when stdin is connected to /dev/null.  This
> second guessing of the user really goes against the unix way and
> shouldn't be there in the first place.  Mean what you say, and say
> what you mean.
> 
> If you must second guess the user and give an interactive prompt just
> in case they made a mistake, then at least only do so when it looks
> like there is a user there.  There is no reason to fail when called
> from a script.
> 
> > There is already the "-f" (force) option to override the cases
> > where this prompt is used, so if the user wants to do something
> > unusual they should use that as part of the script driving mke2fs.
> 
> - --yes-i-meant-what-i-said flags are silly, and make for useless
> inconsistencies between the different mkfs.* utilities that makes
> writing scripts calling them annoyingly difficult.

Yes, it is inconsistent especially in the way that mke2fs is
proceeding without any problem on the device which already contains
a valid file system (or any other) signature. Which I think we
should really change. The problem is that this will break scripts
for everybody which is bad.

So my idea was to implement the signature check and then skip it if
we do not have a tty attached. Just to avoid the breakage.

However I do not think that we can just blindly ignore the checks we
already have in place in the case that there is no user. But I agree
that current behaviour is wrong and it should be changed, however I
think that we need to change it the other way, the default should be
no - do not proceed and exit. Because believe it or not, people make
mistakes.

> 
> > The only time when I think "force" is required when it shouldn't be
> > is in case of full-device formatting.  I don't think this should be
> > considered a problem unless there is already a partition table on
> > the device.  Formatting the whole device is desirable to avoid
> > alignment issues on RAID devices, so I would be happy if that
> > restriction was lifted.

Agreed, but it should not be lifted, but rather changes to check for
signatures on the device. The same way as it is done for example in
xfs, or btrfs.

Thanks!
-Lukas

> 
> The same goes for being run on an image file instead of a device node.
> 
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBAgAGBQJTKJTZAAoJEI5FoCIzSKrwqVcH+wYQkv7lP0Sm2Y52XWbfotAN
> 5yyO3K0w9FFTscHo2YEZ2JE+QdkYadsyuENM41IChNcduJpZjAh6LbVNdlEU9sUq
> v97a+TJq1ahyshl4rxakm5kdXJo1cSZc8cWZoDk3O4ChDhRZdY0fv/uu+sfw0etr
> wYkRNgXB6eNmRSUeIj6rPg3sSKDpNcbcDW3x8cP6Ww+KfLzDtMzEMRkhQpQ13I2P
> eJLebfSQBmiU7hj5xd+TQHORpvk3VxXk4JG1zsytRPekAtNkTFzqi1Uoo75fcTwh
> Nmn2SR2rq1ls81xBTlNQ5gZQ5mUz3ZIuthXWuF3mpP1SW/om3SCM+ay3S0/NNxw=
> =iqNm
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
