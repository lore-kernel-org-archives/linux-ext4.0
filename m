From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext3: Add FITRIM handle for ext3
Date: Tue, 23 Nov 2010 12:06:45 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011231153380.3139@dhcp-lab-213.englab.brq.redhat.com>
References: <1290425358-16253-1-git-send-email-lczerner@redhat.com> <1290425358-16253-2-git-send-email-lczerner@redhat.com> <AANLkTi=Jc1gW1=dLuOzyh4LYGzQ2Dom75bj4vpUY27ts@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, jack@suse.cz, tytso@mit.edu,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Mike Snitzer <msnitzer@redhat.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Jc1gW1=dLuOzyh4LYGzQ2Dom75bj4vpUY27ts@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 22 Nov 2010, Greg Freemyer wrote:

> On Mon, Nov 22, 2010 at 6:29 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> > It takes fstrim_range structure as an argument. fstrim_range is definec in
> > the include/linux/fs.h.
> >
> > After the FITRIM is done, the number of actually discarded Bytes is stored
> > in fstrim_range.len to give the user better insight on how much storage
> > space has been really released for wear-leveling.
> >
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> That's a misleading description in my opinion, from my understanding
> this is more accurate:
> 
> ===
> After the FITRIM is done, the number of bytes passed from the
> filesystem down the block stack to the device for potential discard is
> stored in fstrim_range.len.  This number is a maximum discard amount
> from the storage device's perspective, because FITRIM called repeated
> will keep sending the same sectors for discard repeatedly.
> fstrim_range.len will report the same potential discard bytes each
> time, but only sectors which had been written to between the discards
> would actually be discarded by the storage device.  Further, the
> kernel block layer reserves the right to adjust the discard ranges to
> fit raid stripe geometry, non-trim capable devices in a LVM setup,
> etc.  These reductions would not be reflected in fstrim_range.len.
> 
> As 2.6.37, the kernel block layer does not fully support discard and
> as such will simply ignore all discard requests sent to volumes
> created by device mapper or mdraid.  This is done in a silent way, so
> these failures to discard are also not reflected in fstrim_range.len.

I think this is not entirely true, because we have discard support for
dm linear and stripe:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5ae89a8720c28caf35c4e53711d77df2856c404e
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7b76ec11fec40203836b488496d2df082d5b2022

(Adding Mike Snitzer into cc)

> 
> Thus fstrim_range.len can give the user better insight on how much
> storage space has potentially been released for wear-leveling, but it
> needs to be one of only one criteria the userspace tools take into
> account when trying to optimize calls to FITRIM.
> ===
> 
> Obviously, I'd like to also see that also in API documentation for
> FITRIM.  (And correct me if I'm wrong about device mapper / mdraid.
> I'd love to be wrong about that statement..)
> 
> Greg
> 

Greg, thank you for this, aside the dm thing, this is definitely a lot
better explanation and it would be nice to include this into commit
message (it is too late for ext4:).

Jan, do you want me to repost this with new commit message or you can
add it yourself ?

Thanks!

-Lukas
