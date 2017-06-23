From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Return EIO on read error in ext4_find_entry
Date: Fri, 23 Jun 2017 17:34:23 -0600
Message-ID: <54BEB476-F6E0-4421-B381-92442457910F@dilger.ca>
References: <20170622232307.48392-1-khazhy@google.com>
 <20170623044314.7f23ighkelnpgnah@thunk.org>
 <204110E6-EECE-4925-9020-EC6D9633C822@dilger.ca>
 <20170623122603.jmvyw4oqkojcapv3@thunk.org>
 <C37CE24B-A6E7-4B65-B0C4-4965B3C45007@dilger.ca>
 <CACGdZYJb4ouFMORaMTM5KubJv_SFpms35fXrTdAK0kxsa7-5Cg@mail.gmail.com>
 <20170623232616.r3ffksjntjfbrzgb@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6F66CCBD-A3D8-4458-8102-90C2CAD91269";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Khazhismel Kumykov <khazhy@google.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35449 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753942AbdFWXeb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jun 2017 19:34:31 -0400
Received: by mail-io0-f195.google.com with SMTP id 84so2576466iop.2
        for <linux-ext4@vger.kernel.org>; Fri, 23 Jun 2017 16:34:30 -0700 (PDT)
In-Reply-To: <20170623232616.r3ffksjntjfbrzgb@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6F66CCBD-A3D8-4458-8102-90C2CAD91269
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jun 23, 2017, at 5:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Fri, Jun 23, 2017 at 03:33:46PM -0700, Khazhismel Kumykov wrote:
>> 
>> Giving up early or checking future blocks both work, critical thing
>> here is not returning NULL after seeing a read error.
>> Previously to this the behavior was to continue to check future blocks
>> after a read error, and it seemed OK.
> 
> Whether or not it is OK probably depends on how big the directory is.
> If we need to suffer through N long error retries, whether it is
> caused by long SCSI error retries, or long iSCSI error retries, sooner
> or later it's going to be problematic if the process which is taking
> forever to search through the whole directory has a some kind health
> monitoring service or other watchdog timer.

I think this is a problem regardless of what is being done by the filesystem,
basically if the block device is broken then there will be a lot of retries
and/or errors.  I agree it doesn't make sense to return a benign error like
"ENOENT" if there are IO errors.

> Still, I agree that there will be some cases where instead of "Fast
> fail", having the file server try as hard as possible fetch the file
> from the failing disk is worthwhile.  I tend to be focused on the
> cluster file system case where if it's going to several hundred
> milliseconds to fetch the file, you're better off getting it from the
> one other replicated copies from another server, or start the
> reed-solomon reconstruction from.

Sure, but that is a problem independent of the readdir case I think?

> However, if you have an
> architecture where the only copy of the file is on the particular file
> server (perhaps because you are depending on RAID instead of n=3
> replication or reed-solomon erasure codes), having the file server try
> as hard as possible to find the file is a good thing.
> 
> I wonder if the right answer is to have "fastfail" and "nofastfail"
> mount option.

Wouldn't it just make sense to mount the filesystem with "errors=remount-ro"
or "errors=panic" in your case, where you can give up on a single node
easily if it detects device-level errors, rather than "errors=continue" as
it seems you currently have?  This is what we do in HA environments, and
fail the storage over to a backup server in case the problem is with the
node, SCSI cards, cables, etc. and not the disk (preventing further automatic
failback to prevent node ping-pong if there is actually a media error).

Cheers, Andreas






--Apple-Mail=_6F66CCBD-A3D8-4458-8102-90C2CAD91269
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZTaWCpIg59Q01vtYRAvThAKCmjAd8DOLthCr4OaIHGM4iXGtOJACfbzzj
jNaxeulIJ33ba3MRHs+FAUI=
=+DPm
-----END PGP SIGNATURE-----

--Apple-Mail=_6F66CCBD-A3D8-4458-8102-90C2CAD91269--
