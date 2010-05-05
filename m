From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Wed, 5 May 2010 04:05:11 +0200
Message-ID: <p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
	 <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>
	 <20100504224226.GE6344@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:62870 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760403Ab0EECFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 22:05:14 -0400
Received: by bwz25 with SMTP id 25so2615358bwz.28
        for <linux-ext4@vger.kernel.org>; Tue, 04 May 2010 19:05:11 -0700 (PDT)
In-Reply-To: <20100504224226.GE6344@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 5, 2010 at 12:42 AM,  <tytso@mit.edu> wrote:
> On Mon, May 03, 2010 at 12:47:58PM +0300, Amir G. wrote:
>>
>> Next3 project was introduced 2 weeks ago. I hope you've had a chance
>> to visit the wiki page.
>
> I took a quick look, but to be honest, I've been swamped lately, and
> with the merge window close at hand, it was something I was going to
> put off for another 2-3 weeks. =A0I didn't realize you were in need o=
f
> some immediate comments so that you could finalize the on-disk format=
=2E
>

Indeed, on-disk format changes, that is, the first patch in each of
the e2fsprogs and Next3 patch series,
is the most urgent review for the purpose of finalizing Next3 on-disk f=
ormat.


> So the high bit on that front is that it looks like at least some of
> the fields used, bit positions grabbed, etc., overlap with those used
> by ext4.

I would like to explain a few things regarding on-disk format changes:

1. Whenever it was possible, I tried to grab fields from the end of
the structs (i.e., super_block, s_features, i_flags) to stay as far
away as possible from ongoing changes in Ext4. If you find it better,
I could move these fields to a different location you assign them to.

2. I plea guilt as changed in grabbing i_flags & 0x00F00000 for
snapshot file non-persistent status flags, which overlaps with recent
Ext4 flags. However, I do not, store these flags on-disk, they are
only used by lsattr -X, to display in-memory snapshot status along
with the on-disk snapshot status stored in i_flags & 0x1F000000.

3. I plea guilt as changed in grabbing l_i_reserved1 for snapshot
on-disk list (i_next_snapshot), which overlaps with Ext4 on-disk
i_version. However, since i_version can take any arbitrary value, this
doesn't "break" the Ext4 on-disk format.

The following wiki section lists the on disk format changes in detail:
http://sourceforge.net/apps/mediawiki/next3/index.php?title=3DCode_docu=
mentation#Reserved_fields_and_bits_in_on-disk_structures


> Ext4 is where new development takes place in the ext2/3/4
> series. =A0So enhancements such as Next3 will probably not be receive=
d
> with great welcome into ext3.

Yes, of course, I realize that. This is the reason I chose to
introduce Next3 as a new f/s,
which was branched from Ext3 and not as a new feature to Ext3.
Unfortunately, merging Next3 snapshots feature into Ext4 is not an easy=
 task,
because extent mapped files break the design concepts of Next3 snapshot=
s.

> And as far as e2fsprogs (which handles
> the ext2, ext3, and ext4 file systems) is concerned, I don't want to
> deal with the complexity of certain fields that mean one thing for
> ext4, and something else for Next3.
>

I was kind of expecting you to say that and I understand why that can
be a problem for you.
Let's try to address this issue in the code review and find
alternative solutions.

> I'll try to carve out time to look at the Next3 patches in greater
> detail this week.
>

That would be great.
Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
