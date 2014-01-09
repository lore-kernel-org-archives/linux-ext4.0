From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: A proposal for making ext4's journal more SMR (and flash) friendly
Date: Wed, 8 Jan 2014 20:55:30 -0700
Message-ID: <22006ACD-BC60-4462-B000-CB121DC26FBE@dilger.ca>
References: <nsxfvozavl2.fsf@lambda.thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_FBF949D0-E5DA-41D7-A7E4-9233DE2FFCAC"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40659 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaAIDze (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jan 2014 22:55:34 -0500
Received: by mail-pd0-f174.google.com with SMTP id x10so2605899pdj.5
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jan 2014 19:55:34 -0800 (PST)
In-Reply-To: <nsxfvozavl2.fsf@lambda.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FBF949D0-E5DA-41D7-A7E4-9233DE2FFCAC
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jan 7, 2014, at 10:31 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> This is something I've discussed on our weekly conference calls, but I
> think it's time that try to get it written down.
> 
>                     SMR-Friendly Journal for Ext4
>                              Version 0.10
>                            January 8, 2014
> 
> Design
> ======
> 
> The simplest implementation of this design does not require making any
> on-disk format changes.  We simply suppress the writeback of the dirty
> metadata block to the file system.  Instead we keep a journal map in
> memory, which maps metadata block numbers (or data block numbers if data
> journalling is enabled) to a block number in the journal.
> 
> The journal is not truncated when the file system is unmounted, and so
> there is no difference between mounting a file system which has been
> cleanly unmounted or after a system crash.  In both case, the ext4 file
> system will scan the journal, and create an in-memory data structure
> which maps metadata block locations to their location in the journal.
> When a metadata block (or a data block, if data journalling is enabled)
> needs to be read, if the block number is found in the journal map, the
> block is read from the journal instead of from its "real" location on
> disk.
> 
> Eventually, we will run out of room in the journal, and so we will need
> to retire commits from the head of the journal.  For each block
> referenced in the commit at the head of the journal, if it is has since
> been updated in a newer commit, then no action will be needed.  For a
> block that has not been updated in a newer commit, there are two
> choices.   The checkpoint operation could either copy the block to the
> tail of the journal, or write the block back to its final / "permanent"
> location on disk.   The latter is preferable if it is unlikely that the
> block will needed again, or if space is needed in the journal for other
> metadata blocks.   On the other hand, writing the block to the final
> location on disk will entail a random write, which will be especially
> expensive on SMR disks.  Some experimentation may be needed to determine
> the best hueristics to use.

I've been thinking about something like this for a long time already,
in the context of using a flash/NVRAM device for an external journal,
instead of in the context of SMR, but I think the results are the same.

Since even small flash drives are in the 10s of GB in size, it would be
very useful to use them for log-structured writes to avoid seeks on the
spinning disks.  One would certainly hope that in the age of multi-TB
SMR devices that manufacturers would be smart enough to include a few GB
of flash/NVRAM on board to take the majority of the pain away from using
SMR directly for anything other than replacements for tape drives.

One important change needed for ext4/jbd2 is that buffers in the journal
can be unpinned from RAM before they are checkpointed.  Otherwise, jbd2
requires potentially as much RAM as the journal size.  With a flash or
NVRAM journal device that is not a problem to do random reads to fetch
the data blocks back if they are pushed out of cache.  With an SMR disk
this could potentially be a big slowdown to do random reads from the
journal just at the same time that it is doing random checkpoint writes.

Similarly, with NVRAM journal there is no need to order writes inside
the journal, but with SMR there may be a need to "allocate" blocks in
the journal in some sensible order to avoid pathalogical random seeks
for every single block.  I don't think it will be practical in many
cases to pin the buffers in memory for more than the few seconds that
JBD already does today.

Cheers, Andreas






--Apple-Mail=_FBF949D0-E5DA-41D7-A7E4-9233DE2FFCAC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUs4dsnKl2rkXzB/gAQIE/w/9EjjV+CyKygkLCwLPem6Y+Abz7U7fiWWE
RVfXF/atiZo8wEs6qRWH+QPBQNRTPPnO3mbMl/NzU/KvFFw8sto/aCqedRhxp01u
d+gHUtX68tf9KADtYRr1JfMFLFZ2ckd3Z13Nm29kOwzjfwCBBvxopiCvwiVM+cjv
Z21oN/MvyaVaM6SRWXTj4MtV5Jxod1OnyRddtHv2foNNWPRmu6CyJUbHYejEAPED
fy8SWOSt77BaP9+AvF6h3T6gpeRCVy+q8Ghb1wMNcfUHiLLQNqdDajasBZvnsJP4
VdKKVtV2ZF3bl/IRUhWp1dYFiZ8Nii5OaVu1XsEfLeiMddT0gx3c7/lz8i1NBYM4
x9A2lcToN+Zph2BTH4cEXPD0xqsnnz4fBJ2zLkqBxKfTCh1ZCF4+ZgWg/QWo+kH0
qY8WfjIPynSqrM8jL5ECnupaGg+UDkRPsg7DfsNfB7xfizodEYcUOyGu8TFEu3Th
HecHbUffF+/tc2fx5S5Rt8N7RWPTFXcKwOSqzswkOZR2XEkIHyA+WnYQY3264F7S
tJyURTi78Myx3QqBYuY0vzexSKMpxGuZg0XCEmBeo5ROMG1hqIqlT7VeCoc09Q21
p8EVpbl+N85qqGbIZAlAP+o2gDgRmXatD9Uddr0klgcys97intpLmukeCdGBXflJ
slTDPFe99hg=
=q4/D
-----END PGP SIGNATURE-----

--Apple-Mail=_FBF949D0-E5DA-41D7-A7E4-9233DE2FFCAC--
