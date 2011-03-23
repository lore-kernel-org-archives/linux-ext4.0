From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Wed, 23 Mar 2011 22:19:38 +0200
Message-ID: <AANLkTimuR-oOprBR7Xkehx01ojrdxYOmgqdnX7wNbpt6@mail.gmail.com>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
	<20110204002043.GA15658@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: lsf-pc@lists.linuxfoundation.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>
To: Joel Becker <jlbec@evilplan.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35990 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896Ab1CWUTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Mar 2011 16:19:39 -0400
In-Reply-To: <20110204002043.GA15658@noexit>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 4, 2011 at 2:20 AM, Joel Becker <jlbec@evilplan.org> wrote:
> On Fri, Feb 04, 2011 at 12:33:39AM +0200, Amir Goldstein wrote:
>> I have been working on porting Next3 snapshots to Ext4
>> with a group of 4 CS students.
>>
>> This is where it all happens:
>> https://github.com/amir73il/ext4-snapshots
>>
>> Ext4 snapshots prototype is already working!
>> Would you like to see a demo?
>>
>> I would like to present the progress of our work
>> and discuss the remaining issues and how they should be best address=
ed.
>>
>> Additionally, I would like to discuss the need for a unified snapsho=
ts API that
>> would serve both Ext4 and Btrfs.
>> This could be useful for someone that wants to implement a generic
>> snapshots management system.
>
> =A0 =A0 =A0 =A0ocfs2 definitely wants to be a part of that discussion=
, as we
> already do snapshots and thin clones. =A0ocfs2 snapshots are actually=
 just
> thin clones marked readonly. =A0They can be placed anywhere in the
> filesystem and are first-class inodes. =A0They do not live in a hidde=
n
> space like Next3 snapshots seem to.
> =A0 =A0 =A0 =A0I've already got a design for a front-end snapshot pro=
gram that
> implements a policy on top this generic behavior. =A0This design woul=
d
> cover both first-class and hidden style snapshots, because it assume
> snapshots are in a distinct namespace. =A0I haven't gotten around to
> implementing it yet, but btrfs and other snapshottable filesystems we=
re
> part of the design goal.
>
> Joel
>

Hi Joel,

Any chance of getting a copy of that design of yours, to get a head sta=
rt
for LSF?

Here are some other generic snapshot related topics we may want to disc=
uss:

1. Collaborating the use of inode flags COW_FL, NOCOW_FL, suggested by =
Chris.
2. How to deal with mmap write to COW file, when you get ENOSPC.
3. Adding buffer_remap() flag for buffered I/O code, meaning, there is
an existing mapping to initialize a page on partial write, but still ne=
ed
to call get_block() to get a (possibly) new mapping.

I'll be staying for Collaboration summit, so I've got plenty of time
if you like to exchange some ideas.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
