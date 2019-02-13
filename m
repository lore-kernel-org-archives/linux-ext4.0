Return-Path: <SRS0=kW/n=QU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2848AC0044B
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Feb 2019 21:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3041218EA
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Feb 2019 21:08:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="CwLsbLe0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394722AbfBMVIT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Feb 2019 16:08:19 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:34577 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394707AbfBMVIS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2019 16:08:18 -0500
Received: by mail-pf1-f169.google.com with SMTP id j18so1784400pfe.1
        for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2019 13:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=tDRtxE0Wrd8XdJbVMmboxozkYqIn7hsXzNrJjpNfxV8=;
        b=CwLsbLe0Lr9gKd7IpUivz8B0uirsjlPE8IJEb2W3QRVj6rmbrRuTZ3hwhjbjCHNn1h
         xpoWhaKtPGI8F+JSsgJDLY1HehI02fyUY1MsYf1WwriMQODZr3SWU3iFb+Y7fL8ykBP9
         HQvObzdm7dhgiR/2/0toMks4afJTxwCfSCPscNO6JBqaFwCV996hqDSMqPXyJIABdojC
         XHoTHLq8+66u1D70CjRsNImqh7XdEmBLIUmxogz8iw71JFukmCXVy7hmA+CjkdYh6KsN
         W+UEtqqKpsJHEj2oaFV9wpTyFHgOi4B0IyjA7p23NuzW6D9gDEREMT4F7T+jbQ4h9RBj
         6Rdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=tDRtxE0Wrd8XdJbVMmboxozkYqIn7hsXzNrJjpNfxV8=;
        b=NYmD09uTcKcs7TV5taQ3cwUA12a0BFBHtDWDAlD0MEka3NH9LXlYpje0cqaRNs6UUi
         oimGzeO9XCQbbZ8kr/p8SytQwpqO27eHywzCfU/asyNz+0P2thLMLGyBZVkKtJC5IZ9k
         XSl4cnU1WWWpKiJvep16l+N6/77TurFm/3synP6kfOPH8jkD63g0NkhMcWpuCsxgeiEm
         F8XggORfGsv1oBAWMi1NpLS7Tvoph4PfccprwR36zAVJFCO5jBQdGrR9ABpK9Sh9VBoG
         gB9bjsaYOh7dqRnPmgG7siI59rg6otvadmPO59BtWMH6/UhLiOhU2W4gzJ30DqEUpR40
         XN4g==
X-Gm-Message-State: AHQUAua2axURdn07vh3UqCDXOugoak0sPLcBbohrYzSDyABRcbZFA+oD
        AvxSm7P+2j5FYqXc+hEqN/9SUA==
X-Google-Smtp-Source: AHgI3IaBbmKd/7MCy/eAQ+MNVhCO+ezAvRZA6hBD2295E/xV7SfRGC3YgxvkLjMl1nNKg8JdVIeVXA==
X-Received: by 2002:a63:c303:: with SMTP id c3mr173670pgd.268.1550092096744;
        Wed, 13 Feb 2019 13:08:16 -0800 (PST)
Received: from cabot.adilger.ext (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id z9sm338092pfd.99.2019.02.13.13.08.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 13:08:16 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <57787BFD-0FEA-41C3-87F9-3D402AB223D0@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_062C258B-8783-47DA-9677-FA2D37085EEF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Selective Data Journaling in ext4
Date:   Wed, 13 Feb 2019 14:08:13 -0700
In-Reply-To: <20190213185334.GY23000@mit.edu>
Cc:     Vijay Chidambaram <vijayc@utexas.edu>, linux-ext4@vger.kernel.org,
        jesus.palos@utexas.edu
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
References: <CAHWVdUVW7VMefDQBpas4Trm2SrJupKqKSgAXN9ZiMWJFQCryKA@mail.gmail.com>
 <12FEF208-5FAE-4EE7-93D1-34359A0CBE4F@dilger.ca>
 <CAHWVdUXwzLoeqGjanWYcwQvUqZKJnQnuiSKx=_PjDOz4t1Ox7g@mail.gmail.com>
 <20190213185334.GY23000@mit.edu>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_062C258B-8783-47DA-9677-FA2D37085EEF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 13, 2019, at 11:53 AM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>=20
> On Wed, Feb 13, 2019 at 10:30:47AM -0600, Vijay Chidambaram wrote:
>> Agreed, but another way to view this feature is that it is dynamic
>> switching between ordered mode and data journaling mode. We switch to
>> data journaling mode exactly when it is required, so you are right
>> that most applications would never see a difference. But when it is
>> required, this scheme would ensure stronger semantics are provided.
>> Overall, it provides data-journaling guarantees all the time, and I
>> was thinking some applications would like that peace of mind.
>=20
> Switching back and forth orderred and data journalling mode is a bit
> tricky.  (Insert "one does not simply walk into Morder" meme here).
>=20
> See the comment in ext4_change_journal_flag() in fs/ext4/inode.c:
>=20
> 	/*
> 	 * We have to be very careful here: changing a data block's
> 	 * journaling status dynamically is dangerous.  If we write a
> 	 * data block to the journal, change the status and then delete
> 	 * that block, we risk forgetting to revoke the old log record
> 	 * from the journal and so a subsequent replay can corrupt data.
> 	 * So, first we make sure that the journal is empty and that
> 	 * nobody is changing anything.
> 	 */
>=20
> What this means is that you have to track a list of blocks that has
> ever been data journalled, because before we delete the file, we have
> to write revoke all blocks belonging to that file on the list.
> Similarly, if you switch from ordered to data journalling mode, all of
> those blocks must be revoked.

To avoid the issue of enabling data journaling on a file, and the more
difficult process of disabling data journaling, I think we can be lazy
when disabling data journaling on a file until after the last journal
tid that contains data blocks from the file has been checkpointed out
of the journal.  It isn't like the case where the user requests data
journal be enabled or disabled *now*, so we just need to e.g. put those
files into the orphan list with a journal commit (checkpoint?) callback
to track when the data journal can be removed.

Alternately, just leave the data-journal mode enabled on such files
since they are likely to be used in the same way in the future (or more
likely never modified again) and we never disable data journal.

> This should also be done in a way that avoids serializing parallel
> writes to the the inode.  That's not something we support today (yet),
> but thare are some plans to allow parallel direct I/O writes to the
> file.  Speaking of Direct I/O writes, as above, if a block that was
> previously written via data journalling, the revoke block must be
> submitted --- and committed --- before Direct I/O writes to that block
> can be allowed.
>=20
>>> Since we already have delalloc to pre-stage the dirty pages before =
the
>>> write, we can make a good decision about whether the file data =
should
>>> be written to the journal or directly to the filesystem.
>=20
> Note that delalloc and data journalling is not compatible.  That being
> said, if we are writing to not-yet-allocated block, recent discussions
> of changing ext4 so that we only insert the block into the extent tree
> in a workqueue triggered by the I/O callback for data block write, is
> probably the better way of removing the data=3Dordered overhead.
>=20
> Finally, this optimization only makes sense for HDD's, right?  For
> SSD's, random writes are mostly free, and the cost of the double
> write, not to mention the write amplification effect, probably makes
> this not worthwhile.

Sure, HDDs or hybrid HDDs with SSDs for the journal.  Using the SMR ext4
patches to enable log-structured write mode for ext4 would allow using a
good-sized journal device (32-64GB Optane M.2 devices are cheap and very
fast, and the smallest possible devices that are available today, larger
SSDs are definitely practical to use).  That allows sinking all of the
IOPS into the journal automatically without overwhelming the SSD =
bandwidth
with large writes that can efficiently be made directly to HDDs, and
then the checkpoint can do a better job to order the writes to HDD =
later.
With a RAID system the aggregate HDD bandwidth for large read/write =
exceeds
the SSD bandwidth.

This is definitely a workload that is of real-life interest (mixed large
and small file writes), so being able to optimize this at the ext4 level
would be great.

>> We like this idea as well, and would be happy to work on it! To make
>> sure we are on the same page, the proposal is to:
>> - identify whether writes are sequential or random (1)
>> - Send random writes to journal if Selective Data Journaling is =
enabled (2)
>>=20
>> How should we do (1)? Also, would it make sense to do this per-file
>> instead of as a mode for the entire file system? I am thinking of
>> opening a file with O_SDJ which will convert random writes to
>> sequential and increase performance.

There are really two things to (1) - small random/sync/unaligned writes
into a large file, and small writes to individual files.  The VM already
does similar random/sequential read request detection for large files,
so the same could be used easily for write requests, and the latter can
be done by checking the file size.

Cheers, Andreas






--Apple-Mail=_062C258B-8783-47DA-9677-FA2D37085EEF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxkhz0ACgkQcqXauRfM
H+BrSxAAliBtGvpMmX88FAnDbHQ33m7gEZMpAkZ1u8ou6SFtKPOsvVKVgxQxPMPM
iSgyq5/5nXqA+YV8+7jbTq/0UNkJjM1Yk/s0uepLgvULsMmg4BkhgA13/K0orOEu
J9PDnXtHMjWIfj7cuPFLuJbwBBZ3ue9HjQPplqsh9GLxWqzMqNI9f7YtW0RNGNpp
TtNBN+E+1kMSuYWPH5w1pawdoRVwBziR0uiP8GRoUSVt8mO4aJb91dxnNLG7UM9w
XADxjGzZrTcOQkios7437xtLL4t7sj1KfiZeVSnexKXSPvQc/gHkguW9sANIQRUr
3APiG29/X0OdWy3eik1jvmrpCAZHmn48KGu5wVSpz0HS/JOxCWyU1PJ50csH13QS
B3KaFrtAOA89cYxmQfswp4lM3QjvONxdwK1uhhr3O70Dxxh6K6IbNM8o7gv1pcYX
vGhT7gaBa8JCgX/fF6LUwoiRPTTuoWy2IC4A8Xn1EmtD0LXEVUh6Od6q7tHuMCQB
Ti7d7d6C15UVpFqcqNpl+9LLYE34kTVv3+0jxr0AgxH80k4BGgAuMCRL3iWoi3IO
2mMYU3LMAyvyoN0QIogmT6GXS+o3xIs3Gajx03osqp+Y5uzA7StEyhjom+G2M1rf
ybJ7aW1yi2KLGqaLF9KgtR0Keu0acWEufrhchSDcWG4M0zuVekg=
=qSmz
-----END PGP SIGNATURE-----

--Apple-Mail=_062C258B-8783-47DA-9677-FA2D37085EEF--
