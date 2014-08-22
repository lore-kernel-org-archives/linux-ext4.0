From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Corrupted superblock? But disk still mounts.
Date: Fri, 22 Aug 2014 10:19:12 -0700
Message-ID: <20140822171912.GA10163@birch.djwong.org>
References: <CAMJSjjuRj5-VNs0TeoMEvrozyeJVQH+BUxsBaqO07WH9eKD88w@mail.gmail.com>
 <53F247D5.4030502@redhat.com>
 <CAMJSjjucoP1rGRYKECEb=eoLz29bZQ=z=GHgaz+TUYDf=815ng@mail.gmail.com>
 <53F360FB.1090809@redhat.com>
 <CAMJSjjs=gRuoi5gYeR2hp4Nd9kT6TJb4xxH0cTv2zSEh976UHA@mail.gmail.com>
 <53F76B51.5090709@redhat.com>
 <CAMJSjjtQ742ngjxxfjPW_9H4J6Wr=yt_fCOGv-Hj4nie_q9R3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Mark Ballard <markjballard@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24141 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbaHVRTS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Aug 2014 13:19:18 -0400
Content-Disposition: inline
In-Reply-To: <CAMJSjjtQ742ngjxxfjPW_9H4J6Wr=yt_fCOGv-Hj4nie_q9R3Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 22, 2014 at 05:40:02PM +0100, Mark Ballard wrote:
> No, Eric. I can see it's accurate in its own context. I mean accurate
> in relaying enough information to convey the situation accurately to
> the user. That requires something like e2label to see a wider context,
> and I can see that might actually be an unreasonable expectation. But
> this is what I was getting at: information accurate enough to allow
> non-educated users to get an instant grip of the environment when they
> are forced to go delving under the bonnet (hood) of their computer.
> None of the os componenets were made -- or documented -- with that
> sort of user in mind: someone with less time and experience than is
> really required to work efficiently under there. Yet the application
> environment is such a tangle that users are left with little choice
> but to get their hands dirty. And when you look under there, you see
> that it was made by Heath Robinson but that the drawings were burned
> in a fire.

Perhaps just use a little bit of libmagic to spit out what we might be looking
at if the ext4 sb looks wrong?

# dumpe2fs -h /dev/sda2
dumpe2fs 1.42.11 (09-Jul-2014)
dumpe2fs: Bad magic number in super-block while trying to open /dev/sda
Couldn't find valid filesystem superblock:
/dev/sda2: LUKS encrypted file, ver 1 [aes, xts-plain64, sha1] UUID: <snip>

--D

> 
> On 22 August 2014 17:09, Eric Sandeen <sandeen@redhat.com> wrote:
> > On 8/22/14, 9:19 AM, Mark Ballard wrote:
> >> Ya. It did look that way. 'Scuse me for not checking first.
> >>
> >> But my point is that it may still be a problem for ext4, dumpe2fs,
> >> e2fsck, fsck and presumably gparted and so on.
> >>
> >> That is, would it not be polite of them to report the error ...<drum
> >> roll>... accurately?
> >
> > Ah, I see.  So you don't like "corrupted" - you'd like to know that it's
> > something else perfectly valid, just not the thing you were looking for.
> >
> > Maybe like:
> >
> > # misc/dumpe2fs /dev/sdc1
> > dumpe2fs 1.43-WIP (09-Jul-2014)
> > misc/dumpe2fs: Superblock checksum does not match superblock while trying to open /dev/sdc1
> > Couldn't find valid filesystem superblock.
> > /dev/sdc1 contains a xfs file system
> >
> >
> > # misc/dumpe2fs /dev/sdc
> > dumpe2fs 1.43-WIP (09-Jul-2014)
> > misc/dumpe2fs: Superblock checksum does not match superblock while trying to open /dev/sdc
> > Couldn't find valid filesystem superblock.
> > /dev/sdc is entire device, not just one partition!
> >
> > -Eric
> >
> >> (No irony intended.)
> >>
> >>
> >> On 19 August 2014 15:36, Eric Sandeen <sandeen@redhat.com> wrote:
> >>> On 8/18/14, 3:23 PM, Mark Ballard wrote:
> >>>>> I'm guessing that it's the encryption getting in your way.
> >>>>
> >>>> Cheers, Eric. Does rather look that way. But for the sake of a user report...
> >>>>
> >>>>>
> >>>>> How is /dev/sdb1 encrypted?  Usually this is done with something like dm-crypt.
> >>>>> Or is it hardware encryption managed in the bios?  Did you unlock it?
> >>>>
> >>>> Done with crytpsetup using luks.
> >>>>
> >>>>>
> >>>>> What does "blkid /dev/sdb1" say?
> >>>>>
> >>>>
> >>>> It says Luks.
> >>>
> >>> and not ext4 - so you need to unlock it via mumblemumbleLuksStuffmumblemumble
> >>> before you can operate on it with e2fsprogs tools.
> >>>
> >>> # cryptsetup luksOpen /dev/sdb1 <name>... or something.  Sorry, I'm not a LUKS
> >>> expert...
> >>>
> >>> Anyway, not an ext4 problem.  Your superblock isn't corrupted, it's encrypted.  :)
> >>>
> >>> -Eric
> >>>
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
