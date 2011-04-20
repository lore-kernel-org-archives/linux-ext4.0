From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Wed, 20 Apr 2011 09:53:04 +0800
Message-ID: <BANLkTinHsYgLbGBTnjRD1cJ0HAJXdebW-w@mail.gmail.com>
References: <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419034455.GB23985@dastard>
	<BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
	<20110419074538.GG23985@dastard>
	<20110419140909.GD3030@thunk.org>
	<4DAD987F.5000506@sandeen.net>
	<20110419160114.GE3030@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <david@fromorbit.com>,
	Andreas Dilger <adilger@dilger.ca>, xfs-oss <xfs@oss.sgi.com>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60828 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1DTBxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Apr 2011 21:53:05 -0400
Received: by pzk9 with SMTP id 9so149284pzk.19
        for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 18:53:04 -0700 (PDT)
In-Reply-To: <20110419160114.GE3030@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 20, 2011 at 12:01 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Apr 19, 2011 at 09:13:19AM -0500, Eric Sandeen wrote:
>>
>> But I too am confused about Dave's assertion that it only reflects o=
ndisk state when we have that pesky delalloc flag.
>>
>> Whose idea was that, anyway? ;)
>>
>> I'd certainly buy the argument that it -should- only reflect ondisk =
state, and we should nuke the delalloc flag from orbit, if we could, th=
ough.
>
> I see three options of how we can clarify FIEMAP's semantics:
>
> 1) We define it as only reflecting ondisk state, and nuke the delallo=
c
> flag from orbit.
>
> 2) We state that if the file is currently has unflushed pages in the
> page cache, and FIEMAP_FLAG_SYNC is not passed, whether or not extent=
s
> return the DELALLOC flag or how they handle the UNWRITTEN flag is
> undefined.
>
> 3) We state that FIEMAP is supposed to return information which
> reflects the union of the on-disk and page cache state, with all that
> this implies.
>
> All of these are internally consistent definitions --- we need to
> chose one, document, and then tell the shellutils folks what they
> should do.
>
> In the case of #1 and #2, we really need to implement support for
> SEEK_HOLE/SEEK_DATA for userspace programs like cp who want to know
> this information.
>
> Do we all agree on the problem statement, at least? =A0If so, then we
> can try to come consensus on what is the appropriate solution.

I agree on the problem statement.  Users need to know what FIEMAP
returns definitely.

It seems that Dave is looking at the problem from a different view.

Dave thinks that FIEMAP returns where data exists on disk finally.
Then there are 2 possibilities: unknown and known.  delayed extent is
unknown and others are known.  Although we know where data in
unwritten extent exist finally on disk, we cannot know whether or not
it is being in memory.  However we know data in delayed extent is in
memory. it sounds strange.

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 - Ted
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
