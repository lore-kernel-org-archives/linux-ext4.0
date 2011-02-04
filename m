From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Fri, 4 Feb 2011 07:52:39 +0200
Message-ID: <AANLkTikJthVFj8hpb4TU-jRskSsztBwTOOUMio8KM27B@mail.gmail.com>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
	<20110204002043.GA15658@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Amir Goldstein <amir73il@gmail.com>,
	lsf-pc@lists.linuxfoundation.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45428 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1BDFwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Feb 2011 00:52:40 -0500
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

Cool. I'd love to see a draft (if you already posted it I missed it).
I wonder how one deals with different fs with different snapshot capabi=
lities,
i.e. file level vs. sub/volume level. which one is the case for ocfs2?

> Joel
>
> --
>
> "Sometimes one pays most for the things one gets for nothing."
> =A0 =A0 =A0 =A0- Albert Einstein
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0http://www.jlbec.org/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jlbec@evilplan.org
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
