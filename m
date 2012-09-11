From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: ext4 won't mount - fsck required - 2nd fsck in less than a
 week
Date: Tue, 11 Sep 2012 13:59:47 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.1209111357050.2222@new-host-2>
References: <CAHSRzpC4bnZs1G8BHcuQL6Bf9cKiVb15Ha0sybRdkpwUZbdMKQ@mail.gmail.com> <20120910024709.GA3439@thunk.org> <CAHSRzpDzz4TnQDjunkh3tVHwk5dQHbgEXYCaDE7FOr=U0EZwAw@mail.gmail.com> <CAHSRzpDATS+yMDyw6Wts2DMjyDpJx0rVB5M8QLpKxPFUwHWzXA@mail.gmail.com>
 <CAHSRzpDmw30Z4XqpjcY1DWAv_D701C163fiWJDoWyaLpHPhaMg@mail.gmail.com> <CAHSRzpC1SKr08yS0EvEAkS4JpoiAfZ0ab+PHkZwED02mrVbc-A@mail.gmail.com> <CAHSRzpC8OaMqhYtVuQdet8niRfnvCVwMHi9a6u8fmHdBsy1y2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Terry <td3201@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2IKR7w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Sep 2012 13:59:52 -0400
In-Reply-To: <CAHSRzpC8OaMqhYtVuQdet8niRfnvCVwMHi9a6u8fmHdBsy1y2w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 11 Sep 2012, Terry wrote:

> Date: Tue, 11 Sep 2012 11:22:27 -0500
> From: Terry <td3201@gmail.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: ext4 won't mount - fsck required - 2nd fsck in less than a week
> 
> On Mon, Sep 10, 2012 at 8:56 AM, Terry <td3201@gmail.com> wrote:
> > On Mon, Sep 10, 2012 at 8:48 AM, Terry <td3201@gmail.com> wrote:
> >> On Sun, Sep 9, 2012 at 10:18 PM, Terry <td3201@gmail.com> wrote:
> >>> On Sun, Sep 9, 2012 at 9:53 PM, Terry <td3201@gmail.com> wrote:
> >>>> On Sun, Sep 9, 2012 at 9:47 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >>>>> On Sun, Sep 09, 2012 at 09:34:10PM -0500, Terry wrote:
> >>>>>>
> >>>>>> As the subject says, we have a 15 TB fsck drive that won't mount with
> >>>>>> these errors:
> >>>>>>
> >>>>>> Sep 9 20:02:20 narf kernel: EXT4-fs (dm-9): ext4_check_descriptors:
> >>>>>> Inode bitmap for group 3200 not in group (block 4161027887)!
> >>>>>> Sep 9 20:02:20 narf kernel: EXT4-fs (dm-9): group descriptors corrupted!
> >>>>>
> >>>>> These indicate a very basic file system corruption where the block
> >>>>> group descriptors are corrupted.  E2fsck will complain immediately
> >>>>> upon seeing this sort of fs inconsistency, and the first thing it will
> >>>>> try to do is fix it.
> >>>>>
> >>>>>> We did a proactive fsck on Tuesday of last week because it was
> >>>>>> starting to give filesystem errors. It ran through and mounted fine.
> >>>>>>
> >>>>>> The filesystem lives on an equallogic SAN spread across 36 drives.
> >>>>>> Could this be something with the physical layer or is it not abnormal
> >>>>>> to have to run multiple rounds of fsck to fully fix an issue?
> >>>>>
> >>>>> This is most probably a hardware problem; normally e2fsck will fix
> >>>>> file system corruptions (and certainly problems such as corrupt block
> >>>>> group scriptors) in a single pass.  If e2fsck finished and the file
> >>>>> system mounted fine last week, and now you're getting this kind of
> >>>>> error, it basically screams some kind of physical layer problem, or
> >>>>> perhaps a bad hard drive, or perhaps the SAN disk is getting
> >>>>> incorrectly written to by some other system, etc.
> >>>>>
> >>>>>                                      - Ted
> >>>>
> >>>> Thanks for the reply.  It is part of a RHEL cluster but we did not
> >>>> have any situations where multiple systems mounted the filesystem.  It
> >>>> is a an old SAN so perhaps we have a physical issue. We'll see what it
> >>>> happens with this pass.
> >>>
> >>> While I am waiting for fsck to finish, another thought. This
> >>> filesystem contains a lot of small files. 35,867,642 files to be
> >>> exact.  Anything else I should check or know to ensure a smooth
> >>> operation for these types of filesystems?  I formatted them with
> >>> standard RHEL 6 options.
> >>
> >> FSCK completed fixing a lot of things.  The file system then mounted
> >> without any errors.  We are still getting these types of errors in
> >> /var/log/messages:
> >>
> >> Sep 10 08:40:49 narf kernel: EXT4-fs error (device dm-6):
> >> ext4_dx_find_entry: bad entry in directory #743966900: directory entry
> >> across blocks - block=2975876794offset=0(946176), inode=1414751737,
> >> rec_len=45724, name_len=206
> >>
> >> Thoughts?
> >
> > Hold that thought.  This is another filesystem.  Let me fix that one
> > then come back to this problem if it still exists.
> 
> Ok, fixed the other filesystem (dm-6) yesterday.  Today, getting these
> errors still on it:
> Sep 11 11:17:47 omadvnfs01a kernel: EXT4-fs error (device dm-6):
> ext4_mb_generate_buddy: EXT4-fs: group 90851: 0 blocks in bitmap, 5048
> in gd
> Sep 11 11:18:17 omadvnfs01a kernel: EXT4-fs error (device dm-6):
> ext4_mb_generate_buddy: EXT4-fs: group 90670: 0 blocks in bitmap, 6665
> in gd
> Sep 11 11:19:31 omadvnfs01a kernel: EXT4-fs error (device dm-6):
> ext4_mb_generate_buddy: EXT4-fs: group 37589: 420 blocks in bitmap,
> 8302 in gd
> Sep 11 11:19:31 omadvnfs01a kernel: EXT4-fs error (device dm-6):
> ext4_mb_generate_buddy: EXT4-fs: group 71777: 7071 blocks in bitmap,
> 23711 in gd
> Sep 11 11:19:31 omadvnfs01a kernel: EXT4-fs error (device dm-6):
> ext4_mb_generate_buddy: EXT4-fs: group 71778: 10664 blocks in bitmap,
> 26624 in gd
> Sep 11 11:19:39 omadvnfs01a kernel: EXT4-fs error (device dm-6):
> ext4_mb_generate_buddy: EXT4-fs: group 13499: 9884 blocks in bitmap,
> 1256 in gd
> Sep 11 11:19:39 omadvnfs01a kernel: EXT4-fs error (device dm-6):
> ext4_mb_generate_buddy: EXT4-fs: group 13498: 383 blocks in bitmap,
> 384 in gd
> Sep 11 11:19:39 omadvnfs01a kernel: EXT4-fs error (device dm-6):
> ext4_mb_generate_buddy: EXT4-fs: group 13496: 2356 blocks in bitmap,
> 10453 in gd
> Sep 11 11:19:39 omadvnfs01a kernel: EXT4-fs error (device dm-6):
> ext4_mb_generate_buddy: EXT4-fs: group 13497: 3593 blocks in bitmap,
> 5641 in gd
> Sep 11 11:19:50 omadvnfs01a kernel: EXT4-fs error (device dm-6):
> ext4_mb_generate_buddy: EXT4-fs: group 49528: 25850 blocks in bitmap,
> 29946 in gd

Hi, what RHEL version are you using, or even better what kernel
version are you using ? If you have RHEL subscription, you should
definitely Red Hat about the issue.

Thanks!
-Lukas

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
