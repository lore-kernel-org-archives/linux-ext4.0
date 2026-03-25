Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080F93597B
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 04:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774412817; cv=pass; b=NcxVGoxwYO5n8XGXcb9M2Y4eX5PdsyvdUftviG3IGnwCu3Nzd/BVXOcg++xFFdXcMYdz35VVrPeF3Q9vZOrqFse/sQMrH+F/iBL5jm7D5W7j0LfmImGUGrrXKCAorRMjCF68oCHYYgVW+T9Gz+nq5g7JeJkYIrbJZrWhCWriIbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774412817; c=relaxed/simple;
	bh=rlQ5qRDUnGBaan+lk8XDmZ1jMdwejMC84RadB+1/c58=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=YE7PL1Tt7vahiBO5qWsA+/rUfXSNL9DqnmtC0Nh9IPpRel0dgYT112ui5VEQ9/dlTooheX3d8CLJg5t28WrDaFgMU6RwArL8zqDcBprvSsGkNY/OJLMjwhKhoWO4APJrzitHvwJi/J63mbxxxPAhAVjt68+hczFqyz3UkcDD3f4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GTmY29bZ; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GTmY29bZ"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59de8155501so5999525e87.3
        for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 21:26:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774412814; cv=none;
        d=google.com; s=arc-20240605;
        b=BWED0rffLf2Bq3ye2L+lPqDA2lpnrvo8jgH+24SVfFQbmRmbDTHV6Fh4JvAEb/XZ1H
         ElJAtylhg5YPipp4BBnXtV7Jzg77abSDYbKaI8smrAGN89Qgu2ZffMiOwnyEEJxHKGlE
         IT7Feejle5aH8uIx6fZMC52ZRs6OyQeJ1DNHWpvrbBZeG48hnReJ/VCIp2upy4Ewf17K
         tZVqYd1f0Lt0cwO2fed2eM4UehQvL9ZokNcr6Q6gcjVRyJgI20d3a1mxu88ZIp773SIK
         sW6s+NTETLm/zJtvpm26aHJq5psH5m5b2uBcHEjGZP3FstuHHZpbHxriG3CqfFzU2YC3
         QRYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=6OPJdvVVJVjWlSp6OHdRag8fpj8fXrB+5B/aIMLBPao=;
        fh=Q/B0c4PY58A68tzgR7wcrID2fV15cBPXIdSqA9OG4J0=;
        b=fhgMAdz1Wb9rp6jXs2aidwbytUOui9VVbeYZY8JktamhDBnBHi8fNK/Tf0NNJTMhnA
         9vkPX/Ehj0XF508UfL1kGTjgcm1IwDfEQPoMF21Wc09G/Uni1ud56u82dp7xMUB3jOnG
         TqFIFpGpilK0/wD+dheyDZ232wzPdZdqM0FRbFcA6Irnk23nh8gBCQhFa1a6nxviziUz
         B2zU8QCmwlKzsAFJK0+PMv2Ga89yDGUoKenmCO4Zf6fHFo4MiOpkQfms8Y5Lmr2S2ISz
         Js2lZ5NYBXAPURDbN0X7llriLIAiOD+8ZgqkS7h46AEaUfs4Tg6zCbEECcKZ1XGeiZHr
         biPA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774412814; x=1775017614; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6OPJdvVVJVjWlSp6OHdRag8fpj8fXrB+5B/aIMLBPao=;
        b=GTmY29bZJabOzYGvDrABJzCBRoGWpcJcpfDfdQlA19uOvBCYupL8UvUxHqRNQonKEG
         +XLjuCQ7zhXyyqrDonJXpTdK9yDDqvRODnzlD4I39Ur6/kIdSS+5k5arcTGKNGsqKyOa
         Y9lN9wR4Q5U0wwlvyk6/nAJ6+rgBQwZiE+zRc6G/rPdXsVF+EV1aazvRhqRQV302SlQn
         E/YujVOIOlz9gHxR5hu8BqZW5NASie4Ehbu2AkRw/3fl7JiIpRPtLtZEThQJxTmHZG2B
         SMQaGpTyFZ5owZ87uou+qlKNr2LJAFdZBAbav5o/CRO8P910gwQ86fKWJQWXmIOUcGiT
         cG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774412814; x=1775017614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6OPJdvVVJVjWlSp6OHdRag8fpj8fXrB+5B/aIMLBPao=;
        b=sqF3Xu/AnAZB8puWyBPspzSTic11p1UooqRJqHzDnP/03mN9NVZz0hs4aTJtrhyi8G
         BfLsBGEWEbSnhd4b0T74RLNnBwC7OGjtjzfLYViXdsZGswBDhlO8MTSETxPCg1D4l0z9
         sDQhtjBRoIokd5oL5JoTtGNF7RcyvkABWIVgh+EaqM0zxFkeEe9FjpcafBOvaojdxQPp
         uQjwTsjLQWq54wDAyj3LM+w8zGRvJSl92MzGhbtguTR91lNdtgA6Vr7cq1MoBrCnsR3m
         rqPWm4d9krrUQMGXQPXatNfXw5NmYsgUcPMOh8/X6qshTUciZc0Znhp3r93cA3MCp5Mz
         t4RQ==
X-Gm-Message-State: AOJu0YyyTjK0cp0ZkkD7kBeaElPykRGank09zYHF9eukRLUeRYMpr+Q0
	atOXBWB/am1+4kgw3w6lb7/R9Q0Qd7dSI5nyhetW44ons6WmgV6vdyfZ4/aPb18kmjKpqhiPk79
	J1nfUG2ges7JOC2qGijeTWRjvW3I+U3w=
X-Gm-Gg: ATEYQzyDHj9vrvO2OgGw4LqTGb+/dgtxf9Yt5vqqC9IRdjAyklqkEuDCDXbqtfndC8B
	AS/e7EcXL7IxekZ02bhSEQhKt2UHvwVM4o+ZechR82pvg1bcpExJ7yEOXSKouPUiAD8GbKqP6M0
	FxR8XvtgDyN7NoZos0lFl1n+nf2HHRA0Vr6g6Cc/WdegNWTgZzG49RlQJe018rA69SvKrkhYMdh
	BBvOpaoJ0aYPDvz7HBLQCdGOMBJkca7ntTPRHmjBmGGAJ/Ti6rvGiCv6DbkjorxeHgs1/yw3iYY
	kY7U
X-Received: by 2002:a05:6512:ba7:b0:5a1:44c9:a8ef with SMTP id
 2adb3069b0e04-5a29b98a7a1mr764867e87.26.1774412813932; Tue, 24 Mar 2026
 21:26:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sean Smith <defendthedisabled@gmail.com>
Date: Tue, 24 Mar 2026 23:26:43 -0500
X-Gm-Features: AQROBzB4ZBxWVCZQeija2WLl33uNGJWaQhqmaSkLpWFoNmeK_cslSPttgIWzhWk
Message-ID: <CAOx6djP4hb-Cd1Zk07SNfFfLc8irjNmbVqq+58h1Whz+h1wSFA@mail.gmail.com>
Subject: =?UTF-8?Q?=5BRFC=5D_Proposal=3A_provenance=5Ftime_=28ptime=29_=E2=80=94_a_settab?=
	=?UTF-8?Q?le_timestamp_for_cross=2Dfilesystem_migration?=
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dsterba@suse.com, 
	david@fromorbit.com, brauner@kernel.org, osandov@osandov.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[Email draft produced by AI agent. Reviewed, revised, and submitted by
Sean Smith.]

Hello,

I am writing as a user whose work is directly harmed by the absence
of a settable file creation timestamp in the Linux kernel. I am not a
kernel developer, but I believe this use case may help inform the
ongoing design discussion about btime semantics.

BACKGROUND

I am a disabled Medicaid recipient pursuing pro se civil rights
litigation against Tennessee's Medicaid program. I am building
a suite of AI tools for my litigation. These tools will include
an agentic document management system on Linux
(EndeavourOS/Arch).

My current workflow requires migrating terabytes of case law,
evidence, research, AI Harness project files, and other data
from NTFS (Windows) to Btrfs (Linux) and vice versa. These
documents span years of case history =E2=80=94 some created as far
back as 2014.

I've used Windows exclusively for the past 20 years, and so I
have much to migrate. I am abandoning Windows because it has
repeatedly gotten in the way as I work in OpenCode and with
other AI tools. Linux offers a clearer path to using AI to
build a user-first future. My litigation relies upon my AI
agents and I developing effective AI tools and data systems.
This reliance makes the nonsense that has been going on with
Windows 11 an existential threat. People with disabilities
should not have to ask permission from the legal community or
corporations to have human rights; with an open-source suite
of AI litigation tools, they won't have to.

I provide the above context so that you may better understand
the importance of adopting my modest proposal.

When files are copied from NTFS to Btrfs, every file's creation
date is reset to the moment of the copy. The kernel provides no
syscall to restore the original creation timestamp. The result
is that files created in 2019 after transfer will report being
created in 2026.

For litigation evidence, file creation timestamps are provenance
metadata. They establish when a document first came into existence
as a digital file. Losing this metadata during a routine filesystem
migration is a forensic integrity failure =E2=80=94 it destroys the timelin=
e
that courts, investigators, and opposing counsel may rely on.

For humans and for AI agents, the loss of this metadata limits
how well they can navigate and retrieve from the corpus of
files.

THE PROBLEM AS I UNDERSTAND IT

Omar Sandoval submitted working patches in February 2019 (AT_UTIME_BTIME
for utimensat). They were not merged due to disagreement about whether
btime should be mutable.

The core dispute, as I understand it from the mailing list archives:

  - Dave Chinner (XFS): btime is forensic metadata =E2=80=94 the moment the
    inode was allocated on this specific filesystem. Allowing it to
    be changed destroys its value for filesystem forensic analysis.

  - Ted Ts'o (ext4, March 2025): Proposed distinguishing "btime"
    (forensic, immutable) from "crtime" (settable, for migration
    and Windows compatibility).

  - David Sterba (Btrfs): Acknowledged the need, has a WIP for a
    Btrfs-specific ioctl to set otime. Noted btrfs send/receive
    protocol v2 transmits otime but cannot write it.

Both sides have legitimate points. The impasse exists because one
field is being asked to serve two incompatible purposes.

PROPOSAL: provenance_time (ptime)

I propose a new timestamp concept: provenance_time, abbreviated ptime.

ptime is distinct from btime:

  btime =3D "when was this inode born on THIS filesystem"
          Forensic. Immutable. Set by the kernel at inode creation.
          Valuable for filesystem forensic analysis and intrusion
          detection. Dave Chinner's use case is preserved.

  ptime =3D "when did this file's content first come into existence,
          on any filesystem, as reported by the earliest known source"
          User-settable. Designed for cross-filesystem migration,
          backup/restore, and provenance tracking. Travels with
          the file across copies.

This is similar to Ted Ts'o's btime/crtime split, but with clearer
semantics:

  - "crtime" (creation time) is easily confused with "ctime" (change
    time) and with btime itself. The word "creation" is ambiguous =E2=80=94
    creation of the inode, or creation of the content?

  - "ptime" (provenance time) is unambiguous. It explicitly
    communicates: this timestamp records provenance =E2=80=94 where and
    when this file originated. It makes no claim about the local
    inode's birth. It does not conflict with btime's forensic
    meaning.

ptime fits naturally into the existing timestamp schema:

  atime  - access time
  mtime  - modification time
  ctime  - change time (metadata)
  btime  - birth time (inode, forensic, immutable)
  ptime  - provenance time (origin, settable, travels with file)

IMPLEMENTATION NOTES (from a user's perspective)

  - ptime should be settable via utimensat() or a new dedicated
    syscall, with appropriate privilege requirements (CAP_FOWNER
    or similar).

  - Filesystems that store a creation timestamp (ext4, btrfs, xfs,
    ntfs, exfat) could optionally support ptime using an additional
    inode field, or by allowing the existing crtime/otime field to
    serve as ptime when a filesystem-specific flag is set (as Ted
    suggested for ext4).

  - Standard tools (cp, rsync, tar) could be updated to read and
    write ptime, finally resolving the long-standing inability to
    preserve creation timestamps during file migration on Linux.

  - NTFS-originated filesystems could map their creation time to
    ptime, making Windows-to-Linux migration seamless.

WHO THIS AFFECTS

This is not a niche concern. In researching this issue, I found:

  - Backup/restore users (Duplicati, rsync, rclone all lose btime)
  - Windows-to-Linux migrators frustrated by silent metadata loss
  - Digital forensics professionals whose MACB timelines break
  - Data archivists and media librarians
  - Users with memory/accessibility needs who rely on creation
    dates to track personal document timelines
  - A developer on StackOverflow needing to process 1.3 million
    files with preserved timestamps =E2=80=94 no solution available
  - A 7zip developer filing an issue (Feb 2026) documenting that
    Linux extraction cannot preserve creation times

The common thread across these use cases is that the current
impasse =E2=80=94 where btime's forensic semantics block any settable
timestamp =E2=80=94 produces worse forensic outcomes than providing a
clearly-separated settable field would. The provenance data is
being destroyed precisely because there is no sanctioned place
to put it.

ptime resolves this by giving that data a home without
compromising btime's forensic meaning.

Thank you for considering this proposal.

Sincerely,
Sean Smith
DefendTheDisabled.org
